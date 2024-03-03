# 1. OpenSearch (Open Source Alternative to ElasticSearch)


TODO: add changing kernel soft & hard link related configs

### 1.1 Install OpenSearch 
```bash
sudo apt install -f ./opensearch-2.9.0-linux-x64.deb
```

```bash
sudo systemctl enable opensearch
```

### 1.2 Config OpenSearch

Create the following directories
```bash
sudo mkdir -p /opt/opensearch/{data,logs,snapshots}
```

Change created directories permission
```bash
sudo chown opensearch -R /opt/opensearch
```

Change OpenSearch Config files

Edit file `/etc/opensearch/jvm.options` and change `-Xms` and `-Xmx` options to appropriate values, e.g.:

```yaml
-Xms4g
-Xmx42g
```

Edit file `/etc/opensearch/opensearch.yml` and set the following options in config file:

```yaml
cluster.name: chq-opensearch-cluster
node.name: node-119

network.host: 0.0.0.0

discovery.type: single-node

path.data: /opt/opensearch/data
path.logs: /opt/opensearch/logs
path.repo: ["/opt/opensearch/snapshots"]

#plugins.security.disabled: true

action.auto_create_index: true

bootstrap.memory_lock: false


######## Start OpenSearch Security Demo Configuration ########
# WARNING: revise all the lines below before you go into production
plugins.security.ssl.transport.pemcert_filepath: esnode.pem
plugins.security.ssl.transport.pemkey_filepath: esnode-key.pem
plugins.security.ssl.transport.pemtrustedcas_filepath: root-ca.pem
plugins.security.ssl.transport.enforce_hostname_verification: false
plugins.security.ssl.http.enabled: true
plugins.security.ssl.http.pemcert_filepath: esnode.pem
plugins.security.ssl.http.pemkey_filepath: esnode-key.pem
plugins.security.ssl.http.pemtrustedcas_filepath: root-ca.pem
plugins.security.allow_unsafe_democertificates: true
plugins.security.allow_default_init_securityindex: true
plugins.security.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de

plugins.security.audit.type: internal_opensearch
```

> Note: Opensearch prefers to bind IPv6. Even you specify **network.host: 0.0.0.0**, it does not bind to local interface.
> In this case you must set following config in **/etc/opensearch/jvm.options**:
> ````properties
> -Djava.net.preferIPv4Stack=true
> ````
> and restart the service. you can also look at [its networking document.](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html#network-interface-values). 

### How totally disabling IPv6 in Linux systems:
Edit **/etc/sysctl.conf** file:
```properties
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

Then, reload the configs:
```shell
sudo sysctl -p
```


### 1.3 Start OpenSearch Service
```bash
sudo systemctl start opensearch.service
```

# 2. OpenSearch Dashboards (Open Source Alternative to Kibana)

### 2.1 Install OpenSearch Dashboards
```bash
sudo apt install -f ./opensearch-dashboards-2.9.0-linux-x64.deb
```

```bash
sudo systemctl enable opensearch-dashboards
```

### 2.2 Config OpenSearch Dashboards

Change OpenSearch Dashboards config file, `/etc/opensearch-dashboards/node.options`. Change node memory config e.g.:
```yaml
--max-old-space-size=2048
```

Edit file `/etc/opensearch-dashboards/opensearch_dashboards.yml` and set the following options in config file:
```yaml
server.port: 5601
server.host: "192.168.100.119"

opensearch.hosts: [https://localhost:9200]
opensearch.ssl.verificationMode: none
opensearch.username: kibanaserver
opensearch.password: kibanaserver
opensearch.requestHeadersWhitelist: [authorization, securitytenant]

opensearch_security.multitenancy.enabled: true
opensearch_security.multitenancy.tenants.preferred: [Private, Global]
opensearch_security.readonly_mode.roles: [kibana_read_only]
# Use this setting if you are running opensearch-dashboards without https
opensearch_security.cookie.secure: false

```

### 2.3 Start OpenSearch Dashboards Service
```bash
sudo systemctl start opensearch-dashboards.service
```
