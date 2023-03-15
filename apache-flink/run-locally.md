## Starting a Standalone Cluster (Session Mode)

These steps show how to launch a Flink standalone cluster, and submit an example job:

> we assume to be in the root directory of the unzipped Flink distribution

1. Start Cluster

```bash 
$ ./bin/start-cluster.sh
```

2. You can now access the Flink Web Interface on [http://localhost:8081]()
3. Submit example job

```bash
$ ./bin/flink run ./examples/streaming/TopSpeedWindowing.jar
```

4. Stop the cluster again

```bash
$ ./bin/stop-cluster.sh
```