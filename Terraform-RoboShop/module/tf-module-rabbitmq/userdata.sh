#!/bin/bash
yum install ansible -y &>> /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/abhijeet4022/DevOps-RoboShop.git Ansible-RoboShop/main.yml -e "component=rabbitmq" &>> /opt/userdata.log