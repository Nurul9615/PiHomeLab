#!/bin/bash

prereqs() {
    ansible-playbook ansible/0-install_server_prereqs.yaml -i ~/ansible -u pi
}

create_ssh_key() {
    echo "Creating SSH Key"
    ssh-keygen -t ed25519 -C "ansible" -f $1 -q -N "" 0>&-
    printf "\n"
}

main() {
    create_ssh_key "/home/nurul/.ssh/ansible"
    ssh-copy-id -i /home/nurul/.ssh/ansible.pub pi@192.168.0.10
    eval $(ssh-agent)
    ssh-add /home/nurul/.ssh/ansible

    # prereqs

    # ansible-playbook ansible/1-install_docker_apps.yaml -i ~/ansible -u pi
    # ansible-playbook ansible/2-install_k8s_dashboard.yaml -i ~/ansible -u pi
    # ansible-playbook ansible/3-install_monitoring.yaml -i ~/ansible -u pi
}

main
