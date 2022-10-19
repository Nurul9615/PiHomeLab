#!/bin/bash

# prereqs () {
#     ansible-playbook install_server_prereqs.yaml -i ~/ansible -u pi --ask-pass

#     if [[ ]]; then
#         env
#     elif [[]]; then
#         ene
#     fi
# }

create_ssh_key () {
    echo "Creating SSH Key"
    ssh-keygen -t ed25519 -C "ansible" -f $1 -q -N "" 0>&-
    printf "\n"
}

main () {
    create_ssh_key "/home/nurul/.ssh/ansible"
    ssh-copy-id -i /home/nurul/.ssh/ansible.pub pi@192.168.0.19
}

main

