https://github.com/fluent/fluentd-docker-image/blob/master/README.md

## Build docker image
```bash
docker build --no-cache -t chq/fluentd:v1.15 .
```

## Run fluentd docker container
```bash
mkdir -p log
docker run -it --rm -p 24224:24224 --name chq-logger -v $(pwd)/log:/fluentd/log fluentd/fluentd:v1.15-1
```

> Note:
> - Fluentd needs to fed config file with -c or --config option
> - -v option enables fluentd verbose output.
> - expose udp port with option: -p 24224:24224
> - plugin directory is given as: fluentd --plugin /fluentd/plugins
> - You can also set config file with environment variables:  -v /path/to/conf/test.conf:/fluentd/etc/test.conf -e FLUENTD_CONF=test.conf

Sample:
```bash
docker run -d -p 24224:24224 -p 24224:24224/udp -v /data:/fluentd/log fluent/fluentd:v1.3-debian-1
```

Fluentd directories:
1. Config files:       /fluentd/etc/
2. Plugin directory:   /fluentd/plugins/
3. Logs directory:     /fluentd/log/

More practical command is: 
```bash
docker run -ti --rm -v /path/to/config:/fluentd/etc -v $(pwd)/log:/fluentd/log fluent/fluentd -c /fluentd/etc/<conf> -v
```

## Find the IP address of fluentd container
```bash
docker inspect -f '{{.NetworkSettings.IPAddress}}' chq-logger
```

## Forward container's log to fluentd
```bash
docker run --log-driver=fluentd --log-opt tag="docker.{{.ID}}" --log-opt fluentd-address=FLUENTD.ADD.RE.SS:24224 python:alpine echo Hello
```

Another sample:
```sh
docker run --rm --log-driver=fluentd --log-opt fluentd-address=192.168.2.4:24225 ubuntu echo '...'
```

## Force fluentd container to flush buffered logs
```bash
docker kill -s USR1 chq-logger
```


# Tags
Tags are a major requirement on Fluentd, they allows to identify the incoming data and take routing decisions. By default the Fluentd logging driver uses the container_id as a tag (12 character ID), you can change it value with the fluentd-tag option as follows:

```bash
docker run --rm --log-driver=fluentd --log-opt tag=docker.my_new_tag ubuntu echo "..."
```

Additionally this option allows to specify some internal variables: {{.ID}}, {{.FullID}} or {{.Name}}. e.g:
```bash
docker run --rm --log-driver=fluentd --log-opt tag=docker.{{.ID}} ubuntu echo "..."
```

# Setting fluentd in docker daemon config

To use the fluentd driver as the default logging driver:

```text
/etc/docker/daemon.json

{
   "log-driver": "fluentd",
   "log-opts": {
     "fluentd-address": "fluentdhost:24224"
   }
}
```


# Install and test fluentd locally
```bash
gem install fluentd
fluentd -c fluent.conf &
echo '{"json":"message"}' | fluent-cat debug.test
```

The last command forwards message to fluentd.

For options of different fluent* command line programs refer:
[Fluentd programs](https://docs.fluentd.org/deployment/command-line-option)


# Elasticsearch plugin
URL: [fluent-plugin-elasticsearch](https://github.com/uken/fluent-plugin-elasticsearch)

Install locally:
```bash
gem install fluent-plugin-elasticsearch
```

# Github main repo examples
[Fluentd repo](https://github.com/fluent/fluentd/tree/master/example)


# Github docker image repo
[Docker image repo](https://github.com/fluent/fluentd-docker-image/tree/master/v1.15)


# Docker Options (--log-opt)
Users can use the --log-opt NAME=VALUE flag to specify additional Fluentd logging driver options.

fluentd-address
By default, the logging driver connects to localhost:24224. Supply the fluentd-address option to connect to a different address. tcp(default) and unix sockets are supported.

```bash
docker run --log-driver=fluentd --log-opt fluentd-address=fluentdhost:24224
docker run --log-driver=fluentd --log-opt fluentd-address=tcp://fluentdhost:24224
docker run --log-driver=fluentd --log-opt fluentd-address=unix:///path/to/fluentd.sock
```
Two of the above specify the same address, because tcp is default.

## tag
By default, Docker uses the first 12 characters of the container ID to tag log messages. Refer to the log tag option documentation for customizing the log tag format.

## labels, labels-regex, env, and env-regex
The labels and env options each take a comma-separated list of keys. If there is collision between label and env keys, the value of the env takes precedence. Both options add additional fields to the extra attributes of a logging message.

The env-regex and labels-regex options are similar to and compatible with respectively env and labels. Their values are regular expressions to match logging-related environment variables and labels. It is used for advanced log tag options.

## fluentd-async
Docker connects to Fluentd in the background. Messages are buffered until the connection is established. Defaults to false.

## fluentd-buffer-limit
Sets the number of events buffered on the memory. Records will be stored in memory up to this number. If the buffer is full, the call to record logs will fail. The default is 8192. (https://github.com/fluent/fluent-logger-golang/tree/master#bufferlimit)

## fluentd-retry-wait
How long to wait between retries. Defaults to 1 second.

## fluentd-max-retries
The maximum number of retries. Defaults to 4294967295 (2**32 - 1).

## fluentd-sub-second-precision
Generates event logs in nanosecond resolution. Defaults to false.


# Practical Example
Fluentd Logger:
```bash
docker run -ti --rm --name chq-logger -p 24224:24224 -v $(pwd):/fluentd/etc -v $(pwd)/log:/fluentd/log chq/fluentd:v1.15 -c /fluentd/etc/fluent.conf -v
```

App:
```bash
docker run --rm --log-driver=fluentd --log-opt tag=chq.{{.Name}}  --log-opt fluentd-address=tcp://localhost:24224 ubuntu:22.04 echo 'Hello'
```