#!bin/bash
echo "export ISSOFT_VAR='ubuntu'" >> ~/.bashrc
source ~/.bashrc

mkdir old new current
sudo cp -p /etc/ssh/sshd_config ./old/
sudo cp --no_preserve=all /etc/ssh/sshd_config ./current/
sudo cp -p sshd_config_vm1 ./new/; find ./new/ -exec touch -am --date="$(date -d '-1 year' +'%Y-%m-%d')" {} +
tar -czvf archive.tar.gz old new current
grep -r '/bin/bash' /bin > bin.txt
#wget via env var
wget --tries=50 --connect-timeout=3 --read-timeout=1000 --waitretry=5 http://releases.ubuntu.com/18.04.4/${ISSOFT_VAR}-18.04.4-desktop-amd64.iso
curl https://codeload.github.com/lwwwr/sample-rails-hw/zip/master --output sample.zip
# curl with var from file
cat example | xargs -I{} curl {}