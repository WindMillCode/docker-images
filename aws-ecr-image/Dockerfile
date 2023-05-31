FROM ubuntu:22.04

# node
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive \
    apt-get  -y install  curl gnupg2 git ssh tar gzip ca-certificates lsb-release \
    # python
    g++ gcc autoconf automake bison libc6-dev libffi-dev \
    libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev \
    make pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev \
    # ruby
    wget software-properties-common \
    #circle ci additions \
    unzip jq \
    # e2e additions
    xorg xauth openbox sudo \
    # dev additions
    mlocate vim dos2unix tmux
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install lts/hydrogen && \
	nvm use lts/hydrogen && \
    npm i -g npm && \
    npm install -g yarn



# ruby
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/01-rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/01-rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/01-rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/01-rbenv.sh
RUN chmod +x /etc/profile.d/01-rbenv.sh


# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH "$HOME/.nvm:$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN rbenv install $(rbenv install -l | grep -v - | tail -1)
RUN rbenv rehash
RUN rbenv global $(rbenv install -l | grep -v - | tail -1)

# Give gui access for e2e
RUN groupadd -g 1000 ubuntu && useradd -d /home/ubuntu -s /bin/bash \
    -m ubuntu -u 1000 -g 1000
RUN exec $SHELL

RUN chmod -R 777 /usr/local/rbenv; \
    chmod -R 777 /root/.nvm;

USER root
WORKDIR /


RUN echo "ubuntu ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/ubuntu
RUN    [ -s "$NVM_DIR/nvm.sh" ]  ; \
  . "$NVM_DIR/nvm.sh"  ; \
yarn global add typescript firebase-tools; \
chown -R 0  /root/.nvm/versions/node/$(node -v)/lib/node_modules/firebase-tools/ ;\
curl -sL https://aws-amplify.github.io/amplify-cli/install | bash && $SHELL; \
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

USER root
WORKDIR /
# install chrome & firefox
COPY install_firefox.sh ./
COPY install_chrome.sh ./
COPY install_chromedriver.sh ./
COPY install_geckodriver.sh ./

RUN chmod 777 install_firefox.sh;   ./install_firefox.sh;\
    chmod 777 install_chrome.sh;  ./install_chrome.sh; \
    chmod 777 install_chromedriver.sh;  ./install_chromedriver.sh; \
    chmod 777 install_geckodriver.sh;  ./install_geckodriver.sh;


# delete some files
RUN rm install_firefox.sh install_chrome.sh install_chromedriver.sh install_geckodriver.sh

# java
RUN curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install openjdk@1.17.0" bash

ENV JAVA_HOME=/root/.jabba/jdk/openjdk@1.17.0
ENV PATH $JAVA_HOME/bin:$PATH

# maven
RUN curl -s https://bitbucket.org/mjensen/mvnvm/raw/master/mvn > /bin/mvn && \
    chmod 0755 /bin/mvn


# pyenv
ENV PYENV_ROOT=/root/.pyenv
ENV PATH $PYENV_ROOT/bin:/root/.pyenv/plugins/xxenv-latest/bin:$PATH
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv ;
RUN git clone https://github.com/momo-lab/xxenv-latest.git $(pyenv root)/plugins/xxenv-latest
RUN git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update;
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN echo 'eval "$(pyenv init -)"'  >> /root/.profile ; \
    echo 'eval "$(pyenv init --path)"' >> /root/.profile ; \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.profile \
    echo 'eval "$(pyenv init -)"'  >> /root/.bashrc ; \
    echo 'eval "$(pyenv init --path)"' >> /root/.bashrc ; \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc
RUN pyenv-latest install  ;

# azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash;

# add StaticSitesClient binary

ENV    STATIC_SITES_BINARY  "https://swalocaldeploy.azureedge.net/downloads/1.0.020981/linux/StaticSitesClient"
# RUN echo "export STATIC_SITES_BINARY_VERSION=$(echo $STATIC_SITES_BINARY | grep  -o  -E '[0-9].+[0-9]+')" >> /root/.bashrc
ENV   STATIC_SITES_BINARY_VERSION 1.0.020981
ENV   SWA_CLI_DEPLOY_BINARY  /root/.swa/deploy/1.0.020981/StaticSiteClient


RUN mkdir -p $(dirname $SWA_CLI_DEPLOY_BINARY) && touch $SWA_CLI_DEPLOY_BINARY;\
    wget -o $SWA_CLI_DEPLOY_BINARY $STATIC_SITES_BINARY;\
    STATIC_SITES_BINARY_CHECKSUM=$(sha256sum $SWA_CLI_DEPLOY_BINARY | head -c 64);\
    STATIC_SITES_BINARY_JSON=$HOME/.swa/deploy/StaticSitesClient.json;\
    mkdir -p $(dirname $STATIC_SITES_BINARY_JSON) && touch $STATIC_SITES_BINARY_JSON;\
    echo '{"metadata":   {"version": "stable","buildId": "'$STATIC_SITES_BINARY_VERSION'","publishDate": "2022-09-29T17:37:34.4094014Z","files": {"linux-x64": {"url": "https://swalocaldeploy.azureedge.net/downloads/1.0.020981/linux/StaticSitesClient","sha": "e55db21d0720a12098804559152303e66846bdd94c13a30b30be29a0fc9ae366"},            "win-x64": {        "url": "https://swalocaldeploy.azureedge.net/downloads/1.0.020981/windows/StaticSitesClient.exe",        "sha": "4e4eb72aef26641e236c24929c822500e956bda099ca78054112cadf20261107"      },      "osx-x64": {        "url": "https://swalocaldeploy.azureedge.net/downloads/1.0.020981/macOS/StaticSitesClient",        "sha": "e0f2ae7ec297510a1b3b9332c0dc0dd962a51adb8ea13cd4f3746d79fc24a7e9"      }    }  },    "binary":"'$HOME'/.swa/deploy/'$STATIC_SITES_BINARY_VERSION'/StaticSitesClient",    "checksum":"'$STATIC_SITES_BINARY_CHECKSUM'"}' >> $STATIC_SITES_BINARY_JSON;


# Postgres
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata;\
    apt-get install -yq postgresql

# AWS
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip;rm awscliv2.zip; \
     ./aws/install

COPY 01-custom-docker-setup.sh /etc/profile.d/01-custom-docker-setup.sh
RUN chmod +x /etc/profile.d/01-custom-docker-setup.sh

## AWS EB CLI
RUN git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git; \
    . /etc/profile.d/01-custom-docker-setup.sh; \
    pip install virtualenv;\
    python ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py;

ENV PATH /root/.ebcli-virtual-env/executables:$PATH

# GCP

RUN  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli  google-cloud-cli-app-engine-python google-cloud-cli-app-engine-python-extras -y

# MYSQL
RUN  apt-get -y install mysql-client

# Docker
RUN curl -fsSL https://get.docker.com | sh
