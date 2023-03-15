
## File Systems

Apache Flink uses file systems to consume and persistently store data, both for the results of applications and for fault tolerance and recovery. These are some popular file systems, including **local, hadoop-compatible, Amazon S3, Aliyun OSS and Azure Blob Storage**.
The file system used for a particular file is determined by its URI scheme. For example, `file:///home/user/text.txt` refers to a file in the _local file system_, while `hdfs://namenode:50010/data/user/text.txt` is a file in a specific _HDFS cluster_.

File system instances are instantiated once per process and then cached/pooled, to avoid configuration overhead per stream creation and to enforce certain constraints, such as connection/stream limits.

### Local File System

Flink has built-in support for the file system of the local machine, including any NFS or SAN drives mounted into that local file system. It can be used by default without additional configuration. Local files are referenced with the `file://` URI scheme.


### Add System-File Support 
All file systems are pluggable. That means they can and should be used as plugins. To use a pluggable file system, copy the corresponding JAR file from the opt directory to a directory under plugins directory of your Flink distribution before starting Flink, e.g.

```bash
$ mkdir ./plugins/s3-fs-hadoop
$ cp ./opt/flink-s3-fs-hadoop-1.18-SNAPSHOT.jar ./plugins/s3-fs-hadoop/
```

### Amazon S3

Amazon Simple Storage Service (Amazon S3) provides cloud object storage for a variety of use cases. 
You can use S3 with Flink for reading and writing data as well in conjunction with the streaming state backends.

You can use S3 objects like regular files by specifying paths in the following format:

`s3://<your-bucket>/<endpoint>`

The endpoint can either be a single file or a directory, for example:

```java
// Read from S3 bucket
env.readTextFile("s3://<bucket>/<endpoint>");

// Write to S3 bucket
stream.writeAsText("s3://<bucket>/<endpoint>");

// Use S3 as checkpoint storage
env.getCheckpointConfig().setCheckpointStorage("s3://<your-bucket>/<endpoint>");
```

Note that these examples are not exhaustive and you can use S3 in other places as well, including your high availability setup or the EmbeddedRocksDBStateBackend; 
everywhere that Flink expects a FileSystem URI (unless otherwise stated).

For most use cases, you may use one of our **flink-s3-fs-hadoop** and **flink-s3-fs-presto** _S3 filesystem plugins_ which are self-contained and easy to set up. 
For some cases, however, e.g., for using S3 as YARN’s resource storage dir, it may be necessary to set up a specific Hadoop S3 filesystem implementation.