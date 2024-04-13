#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi

sudo apt-get update
sudo apt-get install docker-compose-plugin

sudo apt-get install git

# Install k3s Pre-requisites
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" | sudo tee -a /boot/cmdline.txt

sudo curl -sfL https://get.k3s.io | sh -s - -write-kubeconfig-mode 644
sudo chmod 755 /etc/rancher/k3s/k3s.yaml
mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chmod 755 ~/.kube/config

systemctl status k3s.service

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm -n kube-system delete traefik traefik-crd
kubectl -n kube-system delete helmchart traefik traefik-crd
touch /var/lib/rancher/k3s/server/manifests/traefik.yaml.skip
systemctl restart k3s

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

pip install openshift pyyaml kubernetes

GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml

sudo k3s kubectl get svc kubernetes-dashboard -n kubernetes-dashboard

kubectl apply -f k8s_dashboard/dashboard.admin-user-role.yml
kubectl apply -f k8s_dashboard/dashboard.admin-user.yml

kubectl apply -f https://downloads.portainer.io/ce2-20/portainer-agent-k8s-nodeport.yaml
# Then use IP as 10.43.41.56:9001

kubectl create namespace monitoring

kubectl apply -f prometheus/clusterRole.yaml prometheus/clusterRole-binding prometheus/config-map.yaml prometheus/prometheus-deployment.yaml prometheus/prometheus-service.yaml -n monitoring

kubectl apply -f kubeStateMetrics/cluster-role.yaml kubeStateMetrics/cluster-role-binding kubeStateMetrics/service-account.yaml kubeStateMetrics/deployment.yaml kubeStateMetrics/service.yaml -n monitoring

kubectl apply -f nodeExporter/daemonset.yaml nodeExporter/nodeExporter-service.yaml

kubectl apply -f grafana/grafana-datasource-config.yaml grafana/grafana-deployment.yaml grafana/grafana-service.yaml