#!/bin/sh
sudo apt-get install git vim zsh rbenv ruby-build mysql-server libmysqlclient-dev libxml2-dev liblzma-dev zlib1g-dev unzip libssl-dev libreadline-dev
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.4.0
git clone git@github.com:fw42/cubecomp.git
