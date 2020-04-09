#!/bin/bash

apt-key adv --fetch-keys https://pkg.jenkins.io/debian/jenkins.io.key
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update
apt install openjdk-8-jre-headless openjdk-8-jre jenkins -y
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
