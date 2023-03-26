Running Portainer Server

```bash
docker run -d -p 8000:8000 -p 9443:9443 \
                --name portainer-ce \
                --restart=always \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v portainer_data:/data \
                portainer/portainer-ee:2.16.2-alpine
```

Running Portainer Agent:

```bash
docker run -d   -v /var/run/docker.sock:/var/run/docker.sock  \
                -v /var/lib/docker/volumes:/var/lib/docker/volumes \
                -v /:/host  \
                -v portainer_agent_data:/data  \
                --restart always   \
                -e EDGE=1  \
                -e EDGE_ID=0805a956-46f5-4b74-aed4-f44f85f8fcaf  \
                -e EDGE_KEY=aHR0cHM6Ly8xOTIuMTY4LjEwMC4xMTc6OTQ0M3wxOTIuMTY4LjEwMC4xMTc6ODAwMHxkOTo5MzoxNjpkNDo3MTo5MDo0NTo1YTo0Nzo0Mjo0Mzo2ZTphMzphZjpiYTpiOXwxMw  \
                -e AGENT_CLUSTER_ADDR=192.168.100.117:9443  \
                -e EDGE_INSECURE_POLL=1 \
                --name portainer_edge_agent \
                portainer/agent:2.16.2-alpine
```