#!/bin/bash

# Run with:
# wget -O- https://bitbucket.org/dbesen/settings/raw/master/redeploy.sh | bash

# TODO test if we're running locally or remotely?
# git remote get-url origin | grep settings

shopt -s extglob

cd
mkdir bitbucket
cd bitbucket
git clone https://dbesen@bitbucket.org/dbesen/settings.git

cd

mkdir bin
pushd bin
ln -sf ../bitbucket/settings/bin/* .
popd

mkdir ~/.ssh
pushd .ssh
ln -sf ../bitbucket/settings/.ssh/* .
popd

ln -sf bitbucket/settings/.!(git) .

sudo yum update
sudo yum install -y zsh util-linux-user

sudo chsh -s $(which zsh) $(whoami)

./bitbucket/settings/git-config

vim '+exit' # install vim plugins

ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -q -N ''
