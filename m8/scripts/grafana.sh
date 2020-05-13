#!bin/bash
apt update
apt-get remove docker docker-engine docker.io
apt-get install     apt-transport-https     ca-certificates     curl     software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt update
apt-get install docker-ce -y
usermod -aG docker ubuntu

docker run -d -p 80:3000 --name grafana grafana/grafana

reboot


# Jenkins - prometheus plugin
# https://grafana.com/grafana/dashboards/6479

# Nexus
# https://github.com/ocadotechnology/nexus-exporter
# docker run -p 9184:9184 -e NEXUS_HOST='http://nexus.alavr.test.coherentprojects.net' -e NEXUS_USERNAME=admin -e NEXUS_ADMIN_PASSWORD='password'  ocadotechnology/nexus-exporter
# https://grafana.com/grafana/dashboards/11702

# Sonarcube
# https://github.com/dmeiners88/sonarqube-prometheus-exporter