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

docker run -p 80:9090 --name prometheus prom/prometheus

reboot

# scrape_configs:
#   - job_name: 'sonarqube'
#     metrics_path: '/api/prometheus/metrics'
#     static_configs:
#       - targets: ['10.0.0.44']

#   - job_name: 'nexus'
#     metrics_path: '/'
#     static_configs:
#       - targets: ['10.0.0.52:9184']

#   - job_name: 'jenkins'
#     metrics_path: '/prometheus'
#     static_configs:
#       - targets: ['10.0.0.12']