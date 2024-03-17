

## Install
- Go to https://packages.fluentbit.io/centos/9/x86_64/
- Download and install appropriate version: e.g. __rpm -ivh fluent-bit-2.2.2-1.x86_64.rpm__   
- It installs as systemd service. If you want to run it:
```sh
/opt/fluent-bit/bin/fluent-bit -c fluent-bit.conf
```

## Run as Docker Container
```sh
docker image pull cr.fluentbit.io/fluent/fluent-bit:2.2.2

docker run -ti cr.fluentbit.io/fluent/fluent-bit:2.2.2 \
  -i cpu -o stdout -f 1
 ```

## Run Locally
```sh
bin/fluent-bit -c fluent-bit.conf
```

Another sample, without setting config file: 
> **-i** for [INPUT], **-p** for [PARSER], **-o** for [OUTPUT]:

```shell
fluent-bit -i tail -p path=/var/log/syslog -o stdout
```

## Config File Format

### Inputs

```editorconfig
## dummy input suitable for testing purposes
[INPUT]
    Name dummy
    Dummy {"endpoint":"localhost", "value":"something"}
    Tag dummy
 
[INPUT]
    name              tail
    path              /var/log/containers/*.log
    multiline.parser  docker, cri

[INPUT]
    Name             tail
    Multiline        On
    Parser_Firstline multiline
    Path             /var/log/java.log


[INPUT]
    Name              tail
    Path              /var/log/containers/*.log
    Parser            json
    DB                /var/log/file_pos.db
    Read_from_Head    true
    Mem_Buf_Limit     5MB
    Skip_Long_Lines   On
    # The interval of refreshing the list of watched files in seconds (For watching new files).
    Refresh_Interval  10
    Tag               chq.*

[INPUT]
    name   tail
    path   lines.txt
    parser json

[INPUT]
    name    tail
    path    /var/ossec/logs/alerts/alerts.json
    tag     wazuh
    parser  json
    Buffer_Max_Size 5MB
    Buffer_Chunk_Size 400k
    storage.type      filesystem
    Mem_Buf_Limit     512MB
```

### Viewing SQLite DB of tailed input files positions:

fluent-bit -i tail -p path=/var/log/syslog -p db=/path/to/logs.db -o stdout
sqlite3 tail.db
> SELECT * FROM in_tail_files;

To config sqlite properly show columns, create a **~/.sqliterc** with following contents:
```text
.headers on
.mode column
.width 5 32 12 12 10
```

The SQLite journaling mode enabled is Write Ahead Log or WAL.


### Outputs

```editorconfig
##  very simple output
[OUTPUT]
    Name stdout

[OUTPUT]
    name   stdout
    match  *

## Send graylog by GELF Protocol
[OUTPUT]
    Name        gelf
    Match       chq*
    Host        192.168.61.163
    Port        12201
    Mode        tcp  # tcp, udp, tls
    Gelf_Short_Message_Key log

## Send graylog by raw tcp Protocol (syslog ?)
[OUTPUT]
    Name  tcp
    Host  *graylog ip address*
    Port  *graylog port*
    net.keepalive off
    Match   wazuh
    Format  json_lines
    json_date_key true

```

### Filters
```editorconfig

[FILTER]
    Name grep
    Match *
    Logical_Op or   # AND , OR
    Regex key something
    Regex key error
    Exclude KEY REGEX

# Use Grep to verify the contents of the iot_timestamp value.
# If the iot_timestamp key does not exist, this will fail
# and exclude the row.
[FILTER]
    Name                     grep
    Alias                    filter-iots-grep
    Match                    iots_thread.*
    Regex                    iot_timestamp ^\d{4}-\d{2}-\d{2}

[FILTER]
    Name                kubernetes
    Match               kube.*
    Kube_URL            https://kubernetes.default.svc.cluster.local:443
    Merge_Log           On
    K8S-Logging.Parser  On


## For json based spring log files (logback-logstash-encoder)
[FILTER]
    Name record_modifier
    Match chq*
    Remove_key  thread_name
    Remove_key  level_value
    Remove_key  @version
    Remove_key  X-Span-Export
    Remove_key  X-B3-SpanId
    Remove_key  X-B3-TraceId
    
[FILTER]
    name   grep
    match  *
    regex  log aa
```

> With record_modifier FILTER you can easily, append new fields. e.g. adds two new fields to the log:
```editorconfig
[FILTER]
    Name record_modifier
    Match *
    Record hostname ${HOSTNAME}
    Record product Awesome_Tool
```

| Key        | Description                                             |
|------------|---------------------------------------------------------|
| Record     | Append fields. This parameter needs key and value pair. |
| Remove_key | If the key is matched, that field is removed.           |

### Record Accessors
A record accessor rule starts with the character $. Using the structured content above as an example the following table describes how to access a record:

```json
{
  "log": "some message",
  "stream": "stdout",
  "labels": {
     "color": "blue",
     "unset": null,
     "project": {
         "env": "production"
      }
  }
}
```

The following table describe some accessing rules and the expected returned value:

| Format                    | Accessed   Value |
|---------------------------|------------------|
| $log                      | "some message"   |
| $labels['color']          | "blue"           |
| $labels['project']['env'] | "production"     |
| $labels['unset']          | null             |
| $labels['undefined']      |                  |


**Usage**
You can use it in _grep_ filters:

```editorconfig
[FILTER]
    name      grep
    match     *
    regex     $labels['color'] ^blue$
```


### Parsers
```editorconfig
# Note this is generally added to parsers.conf and referenced in [SERVICE]
[PARSER]
    Name multiline
    Format regex
    Regex /(?<time>[A-Za-z]+ \d+ \d+\:\d+\:\d+)(?<message>.*)/
    Time_Key  time
    Time_Format %b %d %H:%M:%S

[PARSER]
    Name        json
    Format      json
    Time_Key    @timestamp
    Time_Format %Y-%b-%dT:%H:%M:%S.%L%z

[PARSER]
    Name        docker
    Format      json
    Time_Key    time
    Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    # Command      |  Decoder | Field | Optional Action
    # =============|==================|=================
    Decode_Field_As   escaped    log

[PARSER]
    Name          json
    Format        json
    Time_Key      @timestamp
    Time_Format   %Y-%m-%dT%H:%M:%S.%L
    Time_Keep     On # or Off



[PARSER]
    Name        syslog
    Format      regex
    Regex       ^\<(?<pri>[0-9]+)\>(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$
    Time_Key    time
    Time_Format %b %d %H:%M:%S


```

### Services

```editorconfig

# Service for defined parser files
[SERVICE]
    parsers_file /path/to/parsers.conf

[SERVICE]
    Flush         1
    Log_Level     info
    Daemon        off
    Parsers_File  parsers.conf
    HTTP_Server   On
    HTTP_Listen   0.0.0.0
    HTTP_Port     2020


[SERVICE]
    flush        5
    daemon       Off
    log_level    info
    parsers_file parsers.conf
    plugins_file plugins.conf
    HTTP_Server  Off
    HTTP_Listen  0.0.0.0
    HTTP_PORT    2020
    storage.metrics on
    storage.path /var/log/flb-storage/
    storage.sync normal
    storage.checksum off
    storage.backlog.mem_limit 5M
    Log_File /var/log/td-agent-bit.log
```

