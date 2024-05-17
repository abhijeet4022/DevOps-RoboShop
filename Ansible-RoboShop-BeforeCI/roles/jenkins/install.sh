#!/bin/bash

echo -e "\n\e[32mDownload the repo configuration file.\e[0m"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo >> /tmp/output.log

echo -e "\n\e[32mImport the Key.\e[0m"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key >> /tmp/output.log

echo -e "\n\e[32mInstall pre-requisite packages.\e[0m"
yum install fontconfig java-17-openjdk -y >> /tmp/output.log

echo -e "\n\e[32mInstall jenkins\e[0m"
yum install jenkins -y >> /tmp/output.log

echo -e "\n\e[32mStrat jenkins\e[0m"
systemctl enable jenkins >> /tmp/output.log
systemctl restart jenkins >> /tmp/output.log

echo -e "\n\e[33mJenkin Admin pass is - $(cat /var/lib/jenkins/secrets/initialAdminPassword)\e[0m"

