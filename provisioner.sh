#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt install openjdk-11-jdk
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip
sudo apt install unzip
unzip sonarqube-9.0.1.46107.zip
sudo mv sonarqube-9.0.1.46107 /opt/sonarqube

