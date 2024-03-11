1. Connect into docker image
2. Copy custom_users.yml file inside container.
3. Create a Bcrypt hash based on desired password:

```shell
/usr/share/opensearch/plugins/opensearch-security/tools/hash.sh
```

Then update custom_users.yml file's hash field.

4. Update admin pass by running:

```shell
docker exec opensearch-docker-opensearch-1 \
  /usr/share/opensearch/plugins/opensearch-security/tools/securityadmin.sh  \
  -icl  -t internalusers  -f custom_users.yml   \
  -cacert /usr/share/opensearch/config/root-ca.pem   \
  -cert /usr/share/opensearch/config/admin.pem \
  -key /usr/share/opensearch/config/admin-key.pem \
  --disable-host-name-verification \
  -h 192.168.100.119
```

> Note: Running OpenSearch IP must be given explicitly. 

Warning: Restarting Docker container resets admin password to default. 