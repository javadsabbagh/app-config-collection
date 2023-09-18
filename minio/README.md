
Running minio as docker container:
```bash
export MINIO_TAG=RELEASE.2023-09-16T01-01-47Z
docker run \
  -p 9000:9000 \
  -p 9090:9090 \
  --name minio \
  -v ~/minio/data:/data \
  -e MINIO_ROOT_USER="admin" \
  -e MINIO_ROOT_PASSWORD="minioadmin" \
  quay.io/minio/minio:${MINIO_TAG} server /data --console-address=":9090"
```