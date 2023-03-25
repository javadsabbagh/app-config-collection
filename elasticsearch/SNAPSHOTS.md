
## What is a Snapshot? 
Snapshots are used for index data migration when upgrading ElasticSearch version.
That newer Elastic versions (especially major ones) cannot read old index data directly. Hence, Snapshots are to the rescue.

## Snapshot Management

### 1. Create and Set Physical Repositories Path
First of all, you need a local (or remote, e.g. S3 bucket) repository path for saving/restoring snapshots data.
Then, this path should be enabled in elastic-search docker-compose config:
```yaml
    volumes:
      - ~/elastic-snapshots:/opt/elastic-snapshots
    environment:
      - path.repo=["/opt/elastic-snapshots"]
```

Local install config is located at: `/etc/elasticsearch/elasticsearch.yml`, and sample path location is like this:

```yaml
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
path.repo: ["/opt/elastic-snapshots"]
```

As you see there three important path variables: 
- data
- log
- repo

### 2. Create/Update a Logical Repository
> Note: Repository Names can be anything. 

Create a repository with name `chq_repository` and set the path to one of the repository paths defined in elastic config:
```bash
curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'
``` 

Output: 
```text
{
  "acknowledged" : true
}
```

### 2.1 Verify Repository Exists
```bash
curl -X POST "192.168.100.119:9200/_snapshot/chq_repository/_verify?pretty"
```

Sample output:
```text
{
  "nodes" : {
    "dzxdNJNdRlSVv3j6GD7ybg" : {
      "name" : "dzxdNJN"
    }
  }
}
```

### 3. Take snapshot
Following command takes snapshot of all `chq-*` indices. You should give it a name, e.g. date str (snapshot_2022-12-07).
```bash
curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2023-03-25?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
{
    "indices": "chq-*",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "JavadSabbagh",
        "taken_because": "backup for upgrading/migrating elasticsearch"
    }
}
'
```

Sample output:
```text
{
  "snapshot" : {
    "snapshot" : "snapshot_2023-03-25",
    "uuid" : "IkH9VUCbSbeDXlzvyunkkw",
    "version_id" : 6080099,
    "version" : "6.8.0",
    "indices" : [
      "chq-6.7.1-2022.04.19",
      "chq-6.7.1-2022.12.12",
      ...
    ],
    "include_global_state" : false,
    "state" : "SUCCESS",
    "start_time" : "2023-03-25T13:58:15.441Z",
    "start_time_in_millis" : 1679752695441,
    "end_time" : "2023-03-25T13:58:24.250Z",
    "end_time_in_millis" : 1679752704250,
    "duration_in_millis" : 8809,
    "failures" : [ ],
    "shards" : {
      "total" : 222,
      "failed" : 0,
      "successful" : 222
    }
  }
}
```

### 4. Restore snapshot
```bash
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2023-03-25/_restore?pretty
```

### 5. List Commands
- List all (logical) repositories:
```bash
curl -X GET 192.168.100.119:9200/_snapshot?pretty
```

Sample Output:
```text
{
  "my_repository" : {
    "type" : "fs",
    "settings" : {
      "location" : "/opt/elastic-snapshots"
    }
  },
  "chq_repository" : {
    "type" : "fs",
    "settings" : {
      "location" : "/opt/elastic-snapshots"
    }
  }
}
```

- List all snapshots in a repository:
```bash
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/_all?pretty
```

Sample output:
```text
{
  "snapshots" : [
    {
      "snapshot" : "snapshot_2022-12-7",
      "uuid" : "7KIHWjOHTouIyimraltLqg",
      "version_id" : 6080099,
      "version" : "6.8.0",
      "indices" : [
        "chq-6.7.1-2022.03.06",
        "chq-6.7.1-2022.06.15",
        ...
      ],
      "include_global_state" : false,
      "state" : "SUCCESS",
      "start_time" : "2022-12-07T09:14:04.177Z",
      "start_time_in_millis" : 1670404444177,
      "end_time" : "2022-12-07T09:14:10.317Z",
      "end_time_in_millis" : 1670404450317,
      "duration_in_millis" : 6140,
      "failures" : [ ],
      "shards" : {
        "total" : 204,
        "failed" : 0,
        "successful" : 204
      }
    },
    {
      "snapshot" : "snapshot_2023-03-25",
      "uuid" : "IkH9VUCbSbeDXlzvyunkkw",
      "version_id" : 6080099,
      "version" : "6.8.0",
      "indices" : [
        "chq-6.7.1-2021.08.29",
        "chq-6.7.1-2022.01.22",
        "chq-6.7.1-2021.09.01"
      ],
      "include_global_state" : false,
      "state" : "SUCCESS",
      "start_time" : "2023-03-25T13:58:15.441Z",
      "start_time_in_millis" : 1679752695441,
      "end_time" : "2023-03-25T13:58:24.250Z",
      "end_time_in_millis" : 1679752704250,
      "duration_in_millis" : 8809,
      "failures" : [ ],
      "shards" : {
        "total" : 222,
        "failed" : 0,
        "successful" : 222
      }
    }
  ]
}
```

### Delete Repositories/Snapshots
Delete a specific snapshot:
```bash
curl -X DELETE 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2023-03-25?pretty
```

> Caution: You can also to delete all snapshots in a repository:
 ```bash
curl -X DELETE 192.168.100.119:9200/_snapshot/chq_repository?pretty
```

You need to delete physically data from disk to completely it!
