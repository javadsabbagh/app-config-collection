
Link:
 - https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/resource-providers/standalone/docker/

# Application or Session Mode
Flink's JobManager can be run in Application or Session mode clusters. However, Application mode has a restriction of running only one job.
TaskManager for be run on any cluster.

## Starting a Session Cluster on Docker

A Flink Session cluster can be used to run multiple jobs. Each job needs to be submitted to the cluster after the cluster has been deployed. To deploy a Flink Session cluster with Docker, you need to start a JobManager container. To enable communication between the containers, we first set a required Flink configuration property and create a network:

```bash
$ FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager"
$ docker network create flink-network
```
Then we launch the JobManager:

```bash
$ docker run \
    --rm \
    --name=jobmanager \
    --network flink-network \
    --publish 8081:8081 \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    flink:latest jobmanager
```

and one or more TaskManager containers:

```bash
$ docker run \
    --rm \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    flink:latest taskmanager
```

The web interface is now available at localhost:8081.

Submission of a job is now possible like this (assuming you have a local distribution of Flink available):

```bash
$ ./bin/flink run ./examples/streaming/TopSpeedWindowing.jar
```

To shut down the cluster, either terminate (e.g. with CTRL-C) the JobManager and TaskManager processes, or use docker ps to identify and docker stop to terminate the containers.


## Configuring Flink on Docker 
### 1. Via dynamic properties

It is mostly useful when you run flink from command line, then you pass config params at the end of docker command.

```bash
$ docker run flink:latest \
    <jobmanager|standalone-job|taskmanager|historyserver> \
    -D jobmanager.rpc.address=host \
    -D taskmanager.numberOfTaskSlots=3 \
    -D blob.server.port=6124
```

> Note: Options set via dynamic properties overwrite the options from flink-conf.yaml.

### 2. Via Environment Variables

This method can be used with docker or docker-compose.
You need to pull all configs into FLINK_PROPERTIES environment variable

> Notes:
- > The jobmanager.rpc.address option must be configured, others are optional to set.
- > The environment variable FLINK_PROPERTIES should contain a list of Flink cluster configuration options separated by new line.
- > FLINK_PROPERTIES takes precedence over configurations in flink-conf.yaml.  

#### Docker sample
```bash
$ export FLINK_PROPERTIES="jobmanager.rpc.address: host
taskmanager.numberOfTaskSlots: 3
blob.server.port: 6124
"
$ docker run --env FLINK_PROPERTIES=${FLINK_PROPERTIES} flink:latest <jobmanager|standalone-job|taskmanager>
```

#### Docker Compose Sample
```bash
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.numberOfTaskSlots: 2    
```


### 3. Via flink-conf.yaml

The configuration files (flink-conf.yaml, logging, hosts etc.) are located in the /opt/flink/conf directory in the Flink image. 
To provide a custom location for the Flink configuration files, 
you can mount a volume with the custom configuration files to this path /opt/flink/conf when you run the Flink image:

```bash
$ docker run \
    --mount type=bind,src=/host/path/to/custom/conf,target=/opt/flink/conf \
    --mount type=bind,src=/host/path/to/log4j.properties,target=/opt/flink/conf/log4j.properties \
    flink:latest <jobmanager|standalone-job|taskmanager>
```

The mounted volume must contain all necessary configuration files. 

> Note: The flink-conf.yaml file must have write permission so that the Docker entry point script can modify it in certain cases.


## Old Memory Issues in Flink

> Note: This cofiguration is not needed (just good to know ;-) )

### Switching the Memory Allocator

Flink introduced jemalloc as default memory allocator to resolve memory fragmentation problem (please refer to FLINK-19125).

You could switch back to use glibc as the memory allocator to restore the old behavior or if any unexpected memory consumption or problem observed (and please report the issue via JIRA or mailing list if you found any), by setting environment variable DISABLE_JEMALLOC as true:

```bash
$ docker run \
  --env DISABLE_JEMALLOC=true \
  flink:latest <jobmanager|standalone-job|taskmanager>
```

For users that are still using glibc memory allocator, the glibc bug can easily be reproduced, especially while savepoints or full checkpoints with RocksDBStateBackend are created. Setting the environment variable MALLOC_ARENA_MAX can avoid unlimited memory growth:

```bash
$ docker run \
  --env MALLOC_ARENA_MAX=1 \
  flink:latest <jobmanager|standalone-job|taskmanager>
```