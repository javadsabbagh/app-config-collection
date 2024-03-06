

Getting Error "No eligible node found to execute this request. It's best practice to provision ML nodes to serve your models".

1. Either introduce one node as ML node in opensearch.yml:
```yaml
node.roles: [ ml ]
```
Or 
2. Disable this config in API Console:
```text
PUT _cluster/settings
{
  "persistent": {
    "plugins.ml_commons.only_run_on_ml_node": false
  }
}
```
