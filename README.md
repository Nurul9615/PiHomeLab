- [Services](#services)
- [Kubernetes Dashboard](#kubernetes-dashboard)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## Services

| Service       | Port          |
| ------------- | ------------- |
| Docker        | 10010  |
| Docker Compose| N/A  |
| Heimdall      | 8090  |
| Git           | N/A  |
| K3S           | 6443  |
| Helm          | N/A  |
| Portainer           | 9000  |
| Plex      | 32400  |
| Pi-Hole           | 5335  |
| Kubernetes Dashboard           | 30232  |
| Prometheus      | 30000  |
| KubeStateMetrics     | :8080/metrics  |
| NodeExporter      | 9100/metrics  |
| Grafana     | 32000  |
| Loki     | :3100/:3101/metrics  |
| Nginx Ingress      | 80/443  |
| Transmission     | 9091  |


## Kubernetes Dashboard

```console
sudo k3s kubectl -n kubernetes-dashboard create token admin-user
```

```console
kubectl edit service kubernetes-dashboard -n kubernetes-dashboard

Change from ClusterIP to NodePort by changing:

spec:
  type: NodePort
```

```console
To find the port the dashboard is running on:
sudo k3s kubectl get svc kubernetes-dashboard -n kubernetes-dashboard
E.g. Port 32206
```




















