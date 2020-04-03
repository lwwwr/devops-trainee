#!/bin/bash
sudo apt-get update
sudo apt-get install jq -y
sudo apt-get install tomcat8 tomcat8-examples -y
sudo bash -c 'curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".availabilityZone, .imageId, .privateIp, .region" | cat >> info.txt' 
sudo bash -c 'cat info.txt > /var/lib/tomcat8/webapps/ROOT/index.html'

sudo systemctl restart tomcat8