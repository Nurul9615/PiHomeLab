# PiHomeLab

This will contain all services running on the Raspberry Pi at home.

## Raspberry Pi Config

```console
cat /boot/cmdline.txt
Add "cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to end of line
```

## Kubernetes 

### K3s
Installation of K3S 

```console
sudo iptables -F
sudo reboot
```

```console
sudo curl -sfL https://get.k3s.io | sh -s - -write-kubeconfig-mode 644
sudo chmod 755 /etc/rancher/k3s/k3s.yaml
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

```console
systemctl status k3s.service
k3s kubectl cluster-info
```

### Kubernetes Dashboard

### Prometheus

### Grafana

A

## Docker

### Docker Compose
```console
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo apt install docker-compose
```

### Pi-Hole

```console
mkdir -p docker/pihole
cd docker/pihole/
nano docker-compose.yml
```

Paste the below contents

```console
version: "3"

# More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    # For DHCP it is recommended to remove these ports and instead add: network_mode: "host"
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    #  - "67:67/udp" # Only required if you are using Pi-hole as your DHCP server
      - "5353:80/tcp"
    environment:
      TZ: 'Europe/London'
      WEBPASSWORD: 'password123'
    # Volumes store your data between container upgrades
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    #   https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    cap_add:
      - NET_ADMIN # Required if you are using Pi-hole as your DHCP server, else not needed
    restart: unless-stopped
```

```console
sudo docker-compose up -d
sudo docker container ls
sudo docker-compose run pihole pihole -a -p
```

### Portainer

```console
sudo docker pull portainer/portainer-ce:latest
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

### Plex

```console
docker run -d   --name=plex   --net=host   -e PUID=1000   -e PGID=1000   -e VERSION=docker   -e PLEX_CLAIM= `#optional`   -v /path/to/library:/config   -v /path/to/tvseries:/tv   -v /path/to/movies:/movies   --restart unless-stopped   lscr.io/linuxserver/plex:latest
```
