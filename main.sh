#!/bin/bash

prereqs () {
     ansible-playbook ansible/0-install_server_prereqs.yaml -i ~/ansible -u pi

#     if [[ ]]; then
#         env
#     elif [[]]; then
#         ene
#     fi
}

create_ssh_key () {
    echo "Creating SSH Key"
    ssh-keygen -t ed25519 -C "ansible" -f $1 -q -N "" 0>&-
    printf "\n"
}

main () {
    create_ssh_key "/home/nurul/.ssh/ansible"
    ssh-copy-id -i /home/nurul/.ssh/ansible.pub pi@192.168.0.19
    eval `ssh-agent`
    ssh-add /home/nurul/.ssh/ansible

    # prereqs

    ansible-playbook ansible/1-install_portainer.yaml -i ~/ansible -u pi
    ansible-playbook ansible/2-install_plex.yaml -i ~/ansible -u pi
    ansible-playbook ansible/3-install_pihole.yaml -i ~/ansible -u pi
    ansible-playbook ansible/4-install_k8s_dashboard.yaml -i ~/ansible -u pi
    ansible-playbook ansible/5-install_prometheus.yaml -i ~/ansible -u pi
    ansible-playbook ansible/6-install_kubeStateMetrics.yaml -i ~/ansible -u pi
    ansible-playbook ansible/7-install_nodeExporter.yaml -i ~/ansible -u pi
    ansible-playbook ansible/8-install_grafana.yaml -i ~/ansible -u pi
    ansible-playbook ansible/9-install_loki.yaml -i ~/ansible -u pi
}

main

