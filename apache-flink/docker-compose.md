# Flink with Docker Compose

Docker Compose is a way to run a group of Docker containers locally. The next sections show examples of configuration files to run Flink.


## 1. General

Create the docker-compose.yaml file. Please check the examples in the sections below:
 - Application Mode
 - Session Mode
 - Session Mode with SQL Client

Launch a cluster in the foreground (use -d for background)

```bash
$ docker-compose up
```

Scale the cluster up or down to N TaskManagers
```bash
$ docker-compose scale taskmanager=<N>
```
Access the JobManager container

```bash
$ docker exec -it $(docker ps --filter name=jobmanager --format={{.ID}}) /bin/sh
```

Kill the cluster

```bash
$ docker-compose down
```

### Access Web UI
When the cluster is running, you can visit the web UI at http://localhost:8081.


## 2. Session Mode

In Session Mode you use docker-compose to spin up a long-running Flink Cluster to which you can then submit Jobs.

Sample docker-compose.yml for Session Mode:

```yaml
version: "2.2"
services:
  jobmanager:
    image: flink:latest
    ports:
      - "8081:8081"
    command: jobmanager
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager        

  taskmanager:
    image: flink:latest
    depends_on:
      - jobmanager
    command: taskmanager
    scale: 1
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.numberOfTaskSlots: 2        
```

## 3. Flink SQL Client with Session Cluster

In this example, you spin up a long-running session cluster and a Flink SQL CLI which uses this clusters to submit jobs to.

This is a sample docker-compose.yml for Flink SQL Client with Session Cluster:

```yaml
version: "2.2"
services:
  jobmanager:
    image: flink:latest
    ports:
      - "8081:8081"
    command: jobmanager
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager        

  taskmanager:
    image: flink:latest
    depends_on:
      - jobmanager
    command: taskmanager
    scale: 1
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.numberOfTaskSlots: 2    
              
  sql-client:
    image: flink:latest
    command: bin/sql-client.sh
    depends_on:
      - jobmanager
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        rest.address: jobmanager        
```

In order to start the SQL Client run

```bash
$ docker-compose run sql-client
```

You can then start creating tables and queries those.

Note, that all required dependencies (e.g. for connectors) need to be available in the cluster as well as the client. For example, if you would like to use the Kafka Connector create a custom image with the following Dockerfile

```text
FROM flink:latest
RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_2.12/1.18-SNAPSHOT/flink-sql-connector-kafka_scala_2.12-1.18-SNAPSHOT.jar
```

and reference it (e.g. via the build) command in the Dockerfile. and reference it (e.g via the build) command in the Dockerfile. 
SQL Commands like ADD JAR will not work for JARs located on the host machine as they only work with the local filesystem, which in this case is Docker’s overlay filesystem.
