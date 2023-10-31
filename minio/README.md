
### Running minio as docker container
```bash
export MINIO_TAG=RELEASE.2023-09-16T01-01-47Z
docker run \
  -p 9000:9000 \
  -p 9090:9090 \
  --name minio \
  -v ~/minio/data:/data \
  -e MINIO_ROOT_USER="minioadmin" \
  -e MINIO_ROOT_PASSWORD="$minio@dmin$235" \
  quay.io/minio/minio:${MINIO_TAG} server /data --console-address=":9090"
```


### Enabling ftp server

Starting with MinIO Server RELEASE.2023-04-20T17-56-55Z, you can use the File Transfer Protocol (FTP) to interact with the objects on a MinIO deployment.
In this regard add related options to server command:
```bash
  server                                                  \
    --console-address ":9090"                             \
    --ftp="address=:8021"                                 \
    --ftp="passive-port-range=30000-40000"                \
    --ftp="tls-private-key=path/to/private.key"           \
    --ftp="tls-public-cert=path/to/public.crt"            \
    --sftp="address=:8022"                                \
    --sftp="ssh-private-key=/home/miniouser/.ssh/id_rsa"  \
    /mnt/data
```
>  Note: you can omit tls-private-key, tls-public-key, and ssh-private-key options to use Minio's default cetrificate files.

### MinIO Authentication and Authorization Using OIDC and Keycloak

1- Add keycloak openid config
```bash
mc idp openid add demo test_keycloak \
vendor="keycloak" \
keycloak_realm="minio" scopes="minio-authorization" \
keycloak_admin_url="http://192.168.100.111/auth/admin" \
client_id=minio-client client-secret=rtX713278kJGHX78OIosws09GIIKksh723o \
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
> Default "claim name" is defined "policy" in Minio, so for giving admin access for a user
> use must set "policy" -> "consoleAdmin" in keycloak ui.