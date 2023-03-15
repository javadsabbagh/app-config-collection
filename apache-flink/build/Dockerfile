FROM flink

RUN set -ex; apt-get update; apt-get -y install python

ADD /host/path/to/flink-conf.yaml /container/local/path/to/custom/conf/flink-conf.yaml
ADD /host/path/to/log4j.properties /container/local/path/to/custom/conf/log4j.properties

RUN ln -fs /opt/flink/opt/flink-queryable-state-runtime-*.jar /opt/flink/lib/.

RUN mkdir -p /opt/flink/plugins/flink-s3-fs-hadoop
RUN ln -fs /opt/flink/opt/flink-s3-fs-hadoop-*.jar /opt/flink/plugins/flink-s3-fs-hadoop/.

ENV VAR_NAME value