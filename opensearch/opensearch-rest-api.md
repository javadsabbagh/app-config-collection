
### Generating a BASIC auth value:

You can use the following web site:
https://www.blitter.se/utils/basic-authentication-header-generator/

Or use base64 command in linux:
```shell
$base64
<user>:<password><CTRL+D><generated base64 value>
```

> Note: don't press ENTER before pressing CTRL+D 

> Using **-k** option with curl is to ignore certificate https checking.

## OpenSearch Access Control REST API
https://opensearch.org/docs/latest/security/access-control/api/

### Get Users List
```shell
curl -k -XGET https://192.168.100.119:9200/_plugins/_security/api/internalusers/ -H 'Authorization: Basic YWRtaW46YWRtaW4=' | jq
``` 

### Get specific user info
```shell
curl -k -XGET GET https://192.168.100.119:9200/_plugins/_security/api/internalusers/test_use -H 'Authorization: Basic YWRtaW46YWRtaW4=' | jq
```

### Get Rest API account info
```shell
curl -k -XGET https://192.168.100.119:9200/_plugins/_security/api/account \
 -H 'Authorization: Basic YWRtaW46YWRtaW4=' | jq
```

## DLS
Documents URL:
https://opensearch.org/docs/latest/security/access-control/document-level-security/

### Creating Role for Document Level Security (DLS)

```shell
curl -k -XPUT https://192.168.100.119:9200/_plugins/_security/api/roles/access_high -H 'Content-Type: application/json' \
 -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
 --data '{
  "cluster_permissions": [
    "*"
  ],
  "index_permissions": [{
    "index_patterns": [
      "chq*"
    ],
    "dls": "{\"access\": \"high\"}",
    "allowed_actions": [
      "read"
    ]
  }]
 }' | jq
```

You can also create another role without DLS, and assign it to administrators:
```shell
curl -k -XPUT https://192.168.100.119:9200/_plugins/_security/api/roles/access_all -H 'Content-Type: application/json' \
 -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
 --data '{
  "cluster_permissions": [
    "*"
  ],
  "index_permissions": [{
    "index_patterns": [
      "chq*"
    ],
    "allowed_actions" : [ "indices:data/read/search/template" ]
  }]
 }' | jq
 ```


## Assign role to a user
> Note: user roles are known as backend_roles.
In order to assign a role to user you can patch user info:

```shell
curl -k -XPATCH https://192.168.100.119:9200/_plugins/_security/api/internalusers/test_user -H 'Content-Type: application/json' \
 -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
 --data '
 [
  {
    "op": "replace", "path": "/backend_roles", "value": ["access_low","access_medium"]
  }
 ]' | jq
```