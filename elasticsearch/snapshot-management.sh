#!/usr/bin/sh

help() {
  printf "./snapshot.sh [save|restore] <elasticsearch IP:PORT>\n"
  printf "Example:\n\t./snapshot.sh save 192.168.100.111:9200\n"
  printf "\t./snapshot.sh help\n"
}

take_snapshot() {
  echo ""
}

restore_snapshot() {
  echo sddsdsd
}

help

## Create/Update repository
curl -X PUT "localhost:9200/_snapshot/chq_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/opt/elastic-snapshots"
  }
}
'

## List snapshot
curl -X GET 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7?pretty

## Take snapshot
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

## Restore snapshot
curl -X POST 192.168.100.119:9200/_snapshot/chq_repository/snapshot_2022-12-7/_restore?pretty