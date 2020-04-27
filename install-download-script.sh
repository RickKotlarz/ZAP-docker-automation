# Reference URL for Docker isntall guide
#   https://docs.docker.com/install/linux/docker-ce/ubuntu/

sudo su -

# Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them
apt-get remove docker docker-engine docker.io containerd runc

# Update the apt package index:
apt-get update -y

# Install packages to allow apt to use a repository over HTTPS:
#apt-get install \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg-agent \
#    software-properties-common -y

# Download packages for offline install
apt-get download apt-transport-https
apt-get download ca-certificates
apt-get download curl
apt-get download gnupg-agent
apt-get download software-properties-common

#sudo apt list --installed
#sudo apt remove <package_name>
#sudo apt purge <package_name>


# Add Docker’s official GPG key:
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg > docker.gpg
cat docker.gpg | sudo apt-key add -

# Add stable repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
# Install the latest version of Docker Engine (Default location is /var/lib/docker)
#   apt-get install docker-ce \
#	    docker-ce-cli \
#	    containerd.io
apt-get download docker-ce
apt-get download docker-ce-cli
apt-get download containerd.io

# Add an existing user to the Docker group
#   usermod -aG docker existing-user-acct

# Pull latest stable Docker image
#   https://hub.docker.com/r/owasp/zap2docker-stable
sudo docker pull owasp/zap2docker-stable

# Remove installed docker image
#   sudo docker rmi owasp/zap2docker-stable

# Use the following to export and load the ZAP container in an online/offline env.
#   sudo docker save owasp/zap2docker-stable > zap2docker-stable.tar
#   sudo docker load < zap2docker-stable.tar


# Validate Docker is working from their World test
#   docker run hello-world

# Reference URL for zap docker container
# https://github.com/zaproxy/zaproxy/wiki/Docker

# To show Docker container IDs
#   docker ps -a

# Execute a command or shell in a Docker container 
#   docker exec -it <container name> <command>
#   docker exec -it <container name> /bin/ash
#   docker exec -it <container name> /bin/bash

# To stop all Docker containers and remove them
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Run ZAP docker image in headless daemon mode
#   https://github.com/zaproxy/zaproxy/wiki/Docker
#   http://localhost:8080/

# Install Python PIP installer
#    https://github.com/Grunny/zap-cli
# apt install python-pip -y

sudo apt download build-essential \
#	zlib1g-dev \
#	libncurses5-dev \
#	libgdbm-dev \
#	libnss3-dev \
#	libssl-dev \
#	libreadline-dev \
#	libffi-dev \
#	wget \
#	libsigsegv2_2.12-2_amd64.deb \
#	gawk_1%3a4.2.1+dfsg-1.1build1_amd64.deb
	
# Latest version of python
#	https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz

# Set ZAP API key to random string and store that value in the zapkey variable and zapkey file
mkdir -p /opt/zap
chmod 0775 /opt/zap
touch /opt/zap/target_url_list.txt

zapkey=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '') 
echo $zapkey > /opt/zap/zapkey

# Creating "zapdockerlaunch.sh" file 
#    docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap.sh -daemon -host 0.0.0.0 -port 8080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.key=$(cat \/opt\/zap\/zapkey) &
echo "docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap.sh -daemon -host 0.0.0.0 -port 8080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.key=\$(cat \/opt\/zap\/zapkey) &" > /opt/zap/zapdockerlaunch.sh


chmod -R 0664 /opt/zap/*
chown -R zap.svc:docker /opt/zap
chmod 0770 /opt/zap/zapdockerlaunch.sh
chown zap.svc:docker /opt/zap/zaptargets.sh
chmod 0750 /opt/zap/zaptargets.sh

# Run ZAP through the browser via WebSwing UI
#   http://localhost:8080/zap/
# docker run -u zap -p 8080:8080 -p 8080:8080 -i owasp/zap2docker-stable zap-webswing.sh

# Remove previous scan data
#curl "http://localhost:8080/JSON/spider/action/removeAllScans/?apikey=$(cat \/opt\/zap\/zapkey)"
#curl "http://localhost:8080/JSON/ascan/action/removeAllScans/?apikey=$(cat \/opt\/zap\/zapkey)"
#curl "http://localhost:8080/JSON/alert/action/deleteAllAlerts/?apikey=$(cat \/opt\/zap\/zapkey)"

# Spider a target URL
#zap-cli --zap-url http://127.0.0.1 -p 8080 --api-key $(cat \/opt\/zap\/zapkey) --log-path \/var\/log\/ spider https://public-firing-range.appspot.com/angular/index.html

# Active scan a target URL
#zap-cli --zap-url http://127.0.0.1 -p 8080 --api-key $(cat \/opt\/zap\/zapkey) --log-path \/var\/log\/ active-scan https://public-firing-range.appspot.com/angular/index.html

# Generate HTML report of scanned target 
#zap-cli --zap-url http://127.0.0.1 -p 8080 --api-key $(cat \/opt\/zap\/zapkey) --log-path \/var\/log\/ report -f html -o target.html


# Need to set up cron job for zap.svc account to execute this
# The following will run the spider and active scan script (zapscan.sh) on all targets at midnight
# 00 00 * * * zap.svc /opt/zap/zaptargets.sh


