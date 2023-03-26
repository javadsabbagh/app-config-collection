
## Install Manually

### Download and Extract
```bash
$ export TIKV_VERSION=v6.5.1
$ export GOOS=linux  # only {darwin, linux} are supported
$ export GOARCH=amd64 # only {amd64, arm64} are supported
$ wget -c -O  https://tiup-mirrors.pingcap.com/tikv-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
$ wget -c -O  https://tiup-mirrors.pingcap.com/pd-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
$ tar -xzf tikv-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
$ tar -xzf pd-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
```

### Start PD instance.

```bash
$ ./pd-server --name=pd --data-dir=/tmp/pd/data --client-urls="http://127.0.0.1:2379" --peer-urls="http://127.0.0.1:2380" --initial-cluster="pd=http://127.0.0.1:2380" --log-file=/tmp/pd/log/pd.log
```

### Start TiKV instance

```bash
$ ./tikv-server --pd-endpoints="127.0.0.1:2379" --addr="127.0.0.1:20160" --data-dir=/tmp/tikv/data --log-file=/tmp/tikv/log/tikv.log
```