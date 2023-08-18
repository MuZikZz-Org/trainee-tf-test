#!/usr/bin/env bash

sudo apt-get update
echo "update done"
# sudo apt-get -y upgrade
# echo "upgrade done"
sudo apt-get install openjdk-11-jdk
echo "install openjdk done"
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip
echo "get sonarqube done"
sudo apt-get install unzip
echo "install unzip done"
unzip sonarqube-9.0.1.46107.zip
echo "unzip done"
sudo mv sonarqube-9.0.1.46107 /opt/sonarqube
echo "mv done"

