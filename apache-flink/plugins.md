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
