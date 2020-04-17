sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce -y
#sudo systemctl status docker
sudo usermod -aG docker ${USER}
sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
git clone https://github.com/lwwwr/backend-devops-training-project

sudo bash -c 'cat <<EOF > ./backend-devops-training-project/.env
DB_USERNAME=helloworld
DB_PASSWORD=helloworld
DB_URL=db.alavr.test.coherentprojects.net
DB_PORT=5432
DB_NAME=helloworld
EOF' && 
sudo docker-compose -f ./backend-devops-training-project/docker-compose.yml up -d