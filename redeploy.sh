#!/bin/bash

# Run with:
# wget -O- https://bitbucket.org/dbesen/settings/raw/master/redeploy.sh | bash

# TODO test if we're running locally or remotely?
# git remote get-url origin | grep settings

cd
mkdir bitbucket
cd bitbucket
git clone git@bitbucket.org:dbesen/settings.git
cd settings

mkdir ~/bin
ln -s bin/* ~/bin

mkdir ~/.ssh
ln -s .ssh/* ~/.ssh

ln -s .* ~
