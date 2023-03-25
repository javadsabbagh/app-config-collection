
## What is a Snapshot? 
Snapshots are used for index data migration when upgrading ElasticSearch version.
That newer Elastic versions (especially major ones) cannot read old index data directly. Hence, Snapshots are to the rescue.

## Snapshot Management

### 1. Create and Set Physical Repositories Path
First of all, you need a local (or remote, e.g. S3 bucket) repository path for saving/restoring snapshots data.
Then, this path should be enabled in elastic-search config:
```yaml
    volumes:
      - ~/elastic-snapshots:/opt/elastic-snapshots
    environment:
      - path.repo=["/opt/elastic-snapshots"]
```

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

Verify a Repository
```bash
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/_verify
```

### 3. Take snapshot
Following command takes snapshot of all `chq-*` indices. You should give it a name, e.g. date str (snapshot_2022-12-07).
```bash
curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-07?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
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

### 4. Restore snapshot
```bash
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-07/_restore?pretty
```

### 5. List snapshots
```bash
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-07?pretty
```

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/my_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'
curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'
curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

 POST 192.168.100.119:9200/_snapshot/my_repository/_verify
 curl -X POST 192.168.100.119:9200/_snapshot/my_repository/_verify
 curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/_verify
 curl -X GET 192.168.100.119:9200/_snapshot/chq_repository
 curl -X GET 192.168.100.119:9200/_snapshot/chq_repository?pretty

 curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?wait_for_completion=true" -H 'Content-Type: application/json' -d'
{
    "indices": "index_1,index_2",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "user123",
        "taken_because": "backup before upgrading"
    }
}
'
 curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?wait_for_completion=true?pretty" -H 'Content-Type: application/json' -d'
{
    "indices": "index_1,index_2",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "user123",
        "taken_because": "backup before upgrading"
    }
}
'
 curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?wait_for_completion=true?pretty" -H 'Content-Type: application/json' -d'
{
    "indices": "index_1,index_2",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "user123",
        "taken_because": "backup before upgrading"
    }
}
'
  curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
{
    "indices": "index_1,index_2",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "user123",
        "taken_because": "backup before upgrading"
    }
}
'
 curl -X PUT "192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
{
    "indices": "chq-*",
    "ignore_unavailable": true,
    "include_global_state": false,
    "metadata": {
        "taken_by": "user123",
        "taken_because": "backup before upgrading"
    }
}
'

curl -X GET 192.168.100.119:9200/_snapshot/my_repository/my_snapshot?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/my_snapshot?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/chq_snapshot?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/_status?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository?pretty
curl -X GET 192.168.100.119:9200/_snapshot?pretty
curl -X GET 192.168.100.119:9200/_snapshot/_status?pretty
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository?pretty
curl -X GET 192.168.100.119:9200/_snapshot/?pretty
curl -X POST 192.168.100.119:9200/_snapshot/my_repository/my_snapshot/_restore
curl -X POST 192.168.100.119:9200/_snapshot/my_repository/my_snapshot/_restore?prettu
curl -X POST 192.168.100.119:9200/_snapshot/my_repository/my_snapshot/_restore?pretty
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/my_snapshot/_restore?pretty
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/snapshot-2022-12-7/_restore?pretty
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7/_restore?pretty