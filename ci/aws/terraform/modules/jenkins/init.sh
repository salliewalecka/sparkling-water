#!/usr/bin/env bash

sudo apt update -y
sudo apt upgrade -y
sudo add-apt-repository universe
sudo apt install openjdk-8-jre-headless openjdk-8-jre -y
sudo apt update
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
