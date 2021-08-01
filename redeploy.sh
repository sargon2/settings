#!/bin/bash

# Run with:
# wget -O- https://bitbucket.org/dbesen/settings/raw/master/redeploy.sh | bash

# TODO test if we're running locally or remotely?
# git remote get-url origin | grep settings

cd
mkdir bitbucket
cd bitbucket
git clone https://dbesen@bitbucket.org/dbesen/settings.git

cd

mkdir bin
ln -sf bitbucket/settings/bin/* bin/

mkdir ~/.ssh
ln -sf bitbucket/settings/.ssh/* .ssh/

ln -sf bitbucket/settings/.* .

sudo yum update
sudo yum install -y zsh
