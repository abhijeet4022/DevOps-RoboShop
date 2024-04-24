#!/bin/bash
yum install ansible bash-completion -y &>> /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/abhijeet4022/DevOps-RoboShop.git Ansible-RoboShop/main.yml -e component="${var.component}" &>> /opt/userdata.log