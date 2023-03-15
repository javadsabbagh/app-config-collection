# Plugins

> Note: Currently, ***file systems*** and ***metric reporters*** are pluggable but in the future, *connectors*, *
> formats*, and even *user code* should also be pluggable.

## Isolation and plugin structure

Plugins reside in their own folders and can consist of several jars. The names of the plugin folders are arbitrary.

```text
flink-dist
├── conf
├── lib
...
└── plugins
    ├── s3
    │   ├── aws-credential-provider.jar
    │   └── flink-s3-fs-hadoop.jar
    └── azure
        └── flink-azure-fs-hadoop.jar
```

## Metric Reporters

Metrics can be exposed to an external system by configuring one or several reporters in conf/flink-conf.yaml.
These reporters will be instantiated on each job and task manager when they are started.

### Identifiers vs. tags

There are generally 2 formats for how reporters export metrics.

* **Identifier-based** reporters assemble a flat string containing all scope information and the metric name. An example could be job.MyJobName.numRestarts.
* **Tag-based** reporters on the other hand define a generic class of metrics consisting of a logical scope and metric name (e.g., job.numRestarts), and report a particular instance of said metric as a set of key-value pairs, so called “tags” or “variables” (e.g., “jobName=MyJobName”).

### Push vs. Pull

Metrics are exported either via pushes or pulls.

* **Push-based** reporters usually implement the Scheduled interface and periodically send a summary of current metrics to an external system.
* **Pull-based** reporters are queried from an external system instead.

### Prometheus

Type: pull/tags

```java
org.apache.flink.metrics.prometheus.PrometheusReporter
```

Parameters:

* **port** - (optional) the port the Prometheus exporter listens on, defaults to 9249. In order to be able to run several
  instances of the reporter on one host (e.g. when one TaskManager is colocated with the JobManager) it is advisable to
  use a port range like 9250-9260.
* **filterLabelValueCharacters** - (optional) Specifies whether to filter label value characters. If enabled, all characters
  not matching [a-zA-Z0-9:_] will be removed, otherwise no characters will be removed. Before disabling this option
  please ensure that your label values meet the Prometheus requirements.

Example configuration:

```yaml
metrics.reporter.prom.factory.class: org.apache.flink.metrics.prometheus.PrometheusReporterFactory
```

Flink metric types are mapped to Prometheus metric types as follows:

| Flink     | Prometheus | Note                                       |
|-----------|------------|--------------------------------------------|
| Counter   | Gauge      | Prometheus counters cannot be decremented. |
| Gauge     | Gauge      | Only numbers and booleans are supported.   |
| Histogram | Summary    | Quantiles .5, .75, .95, .98, .99 and .999  |
| Meter     | Gauge      | The gauge exports the meter’s rate.        |

All Flink metrics variables (see List of all Variables) are exported to Prometheus as labels.

### PrometheusPushGateway

Type: push/tags

```java
org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter)
```

**Parameters:**

| Key                        | Type    | Default | Description                                                                                                                                                                                                                                                             |
|----------------------------|---------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| deleteOnShutdown           | Boolean | true    | Specifies whether to delete metrics from the PushGateway on shutdown. Flink will try its best to delete the metrics but this is not guaranteed. See here for more details.                                                                                              | 
| filterLabelValueCharacters | Boolean | true    | Specifies whether to filter label value characters. If enabled, all characters not matching [a-zA-Z0-9:_] will be removed, otherwise no characters will be removed. Before disabling this option please ensure that your label values meet the Prometheus requirements. |
| groupingKey                | String  | (none)  | Specifies the grouping key which is the group and global labels of all metrics. The label name and value are separated by '=', and labels are separated by ';', e.g., k1=v1;k2=v2. Please ensure that your grouping key meets the Prometheus requirements.              |
| hostUrl                    | String  | (none)  | The PushGateway server host URL including scheme, host name, and port.                                                                                                                                                                                                  |
| jobName                    | String  | (none)  | The job name under which metrics will be pushed                                                                                                                                                                                                                         |
| randomJobNameSuffix        | Boolean | true    | Specifies whether a random suffix should be appended to the job name.                                                                                                                                                                                                   | 

Example configuration:

```yaml
metrics.reporter.promgateway.factory.class: org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporterFactory
metrics.reporter.promgateway.hostUrl: http://localhost:9091
metrics.reporter.promgateway.jobName: myJob
metrics.reporter.promgateway.randomJobNameSuffix: true
metrics.reporter.promgateway.deleteOnShutdown: false
metrics.reporter.promgateway.groupingKey: k1=v1;k2=v2
metrics.reporter.promgateway.interval: 60 SECONDS
```

The _**PrometheusPushGatewayReporter**_ pushes metrics to a Pushgateway, which can be scraped by Prometheus.

Please see the Prometheus documentation for use-cases.

### Slf4j

Type: push/identifier

```java
org.apache.flink.metrics.slf4j.Slf4jReporter
```

Example configuration:

```yaml
metrics.reporter.slf4j.factory.class: org.apache.flink.metrics.slf4j.Slf4jReporterFactory
metrics.reporter.slf4j.interval: 60 SECONDS
```