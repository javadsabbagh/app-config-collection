

## FIXME this document needs to be corrected and organized 

```bash
docker run --rm --name consul-1.13 \ 
      -p 8500:8500 -p 8600:8600 \
      -v /opt/consul-data-1.13:/consul/data \ 
      -v /opt/consul-config-1.13:/consul/config \ 
      -e CONSUL_CLIENT_INTERFACE=eth0 \
      -e CONSUL_BIND_INTERFACE=eth0 \
      consul:1.13.2
```

```bash
docker run --rm --net=host --name=consul-1.13 \
        -e CONSUL_BIND_INTERFACE=eth0 \ 
        consul:1.13.2
```

```bash
docker run --rm --net=host --name=consul-1.13 \  
        -e 'CONSUL_ALLOW_PRIVILEGED_PORTS='  \
         consul:1.13.2 agent -server -bind=192.168.10.92   -dns-port=53  -recursor=8.8.8.8
```

```bash
docker run --rm --net=host \
        -e CONSUL_CLIENT_INTERFACE=enp0s20f0u5 \ 
        -e CONSUL_BIND_INTERFACE=enp0s20f0u5   \
        -e 'CONSUL_ALLOW_PRIVILEGED_PORTS='    \
        consul:1.13.2 agent -server -dns-port=53 -recursor=192.168.100.2 -bind=192.168.10.92 -client=192.1768.10.92 -bootstrap-expect=1
```

```bash
docker run --name consul -p 8500:8500 \
        -v /opt/consul-data:/consul/data \
        -v /opt/consul-config:/consul/config \
        -e CONSUL_CLIENT_INTERFACE=eth0 \
        -e CONSUL_BIND_INTERFACE=eth0  \
        consul:1.13.2 agent -server -bootstrap 
```

### Environment Variables
```bash
CONSUL_UI_LEGACY=1
CONSUL_DATACENTER_LOCAL=test-dc CONSUL_DATACENTER_PRIMARY=test-dc
```
