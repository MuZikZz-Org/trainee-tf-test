#!/usr/bin/env bash
# Install Java and other dependencies
sudo apt-get update
sudo apt-get install -y openjdk-11-jre-headless unzip

 

# Download and install SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip
unzip sonarqube-9.0.1.46107.zip
mv sonarqube-9.0.1.46107 /opt/sonarqube

 

# Start SonarQube
/opt/sonarqube/bin/linux-x86-64/sonar.sh start
# EOF
