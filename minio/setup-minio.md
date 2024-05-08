
### Running minio as docker container
```bash
export MINIO_TAG=RELEASE.2023-09-16T01-01-47Z
docker run \
  -p 9000:9000 \
  -p 9001:9001 \
  --name minio \
  -v ~/minio/data:/data \
  -e MINIO_ROOT_USER="minioadmin" \
  -e MINIO_ROOT_PASSWORD="minio@dmin$$235" \
  quay.io/minio/minio:${MINIO_TAG} server /data --console-address=":9001"
```

## Running docker as rootless (not root user)
Please add user option to docker command as:
```bash
   --user $(id -u):$(id -g) \
```

### Running MinIO Client (mc)
For using Minio Client (mc), it's better to install it locally:

```bash
$ sudo wget -c https://dl.min.io/client/mc/release/linux-amd64/mc --output-document=/usr/local/bin/mc
$ sudo chmod +x /usr/local/bin/mc
$ mc alias set myminio/ http://MINIO-SERVER ACCESS_KEY SECRET_KEY    ## Access and secret keys should be created inside Minio console admin
```

### MinIO Authentication and Authorization Using OIDC and Keycloak

1- Add keycloak openid config
```bash
mc idp openid add demo test_keycloak \
vendor="keycloak" \
keycloak_realm="minio" scopes="minio-authorization" \
keycloak_admin_url="http://192.168.100.111/auth/admin" \
client_id=minio-client \
client-secret=rtX713278kJGHX78OIosws09GIIKksh723o \
config_url="http://192.168.100.111/realms/minio/.well-known/openid-configuration" \
display_name="MinIO OpenID Login" redirect_uri_dynamic="on"
```

2- Restart demo service 
```bash
mc admin service restart demo
```
3- Add appropriate claims

Notes:
> Claims are defined in attributes section (tab) of keycloak web console.
> Default "claim name" is defined in "policy" attribute, so for giving admin access to user
> you should define an attribute as "policy" -> "consoleAdmin" in the keycloak ui.