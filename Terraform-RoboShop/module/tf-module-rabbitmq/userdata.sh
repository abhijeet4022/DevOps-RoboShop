#!/bin/bash
yum install ansible bash-completion python3.11-pip.noarch -y &>> /opt/userdata.log
pip3.11 install botocore boto3 &>> /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/abhijeet4022/DevOps-RoboShop.git Ansible-RoboShop/main.yml -e component=${component} -e env=${env}&>> /opt/userdata.log