# set the path
export JAVA_HOME=/root/.jabba/jdk/openjdk@1.17.0
export PYENV_ROOT=/root/.pyenv
export RBENV_ROOT=/usr/local/rbenv
export NVM_DIR=/root/.nvm
export PATH=/root/.ebcli-virtual-env/executables:/root/.pyenv/bin:/root/.jabba/jdk/openjdk@1.17.0/bin:/usr/bin/heroku:/root/.amplify/bin:/node_modules/.bin:/node_modules:/root/.nvm/versions/node/v14.17.3/bin:/usr/local/share/pyenv/shims:/usr/local/share/pyenv/bin:/root/.nvm:/usr/local/rbenv/bin:/usr/local/rbenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/pyenv/shims:/usr/local/share/pyenv/bin:/usr/local/rbenv/shims:/usr/local/rbenv/bin:/.nvm:/usr/local/rbenv/bin:/usr/local/rbenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv global $(pyenv latest 3)

[ -s "$NVM_DIR/nvm.sh" ]
. $NVM_DIR/nvm.sh



