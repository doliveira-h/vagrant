#!/bin/bash
echo "Installing OpenJDK"
yum -y install java-1.8.0-openjdk-devel

echo "Creating Jenkins Repository"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo

echo "Import Jenkins Repository key"
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

echo "Installing jenkins"
yum -y install jenkins

echo "Enable Jenkins Service"
systemctl enable jenkins

echo "Restarting Jenkins Service"
systemctl restart jenkins
