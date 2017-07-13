if [ -z $(which docker) ]; then
    sudo apt-get update;
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common;
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable";
    sudo apt-get update;
    sudo apt-get install docker-ce;
else
    echo "Docker is already installed."
fi

if [ -z $(which docker-compose) ]; then
    curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m`
    > /tmp/docker-compose;
    sudo mv /tmp/docker-compose /usr/local/bin/;
    sudo chmod +x /usr/local/bin/docker-compose;
else
    echo "Docker-Compose is already installed."
fi
