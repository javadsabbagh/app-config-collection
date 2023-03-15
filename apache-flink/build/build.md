
## Building Custom Dokcer Image

```sh
$ docker build --tag custom_flink_image .
# optional push to your docker image registry if you have it,
# e.g. to distribute the custom image to your cluster
$ docker push custom_flink_image
```