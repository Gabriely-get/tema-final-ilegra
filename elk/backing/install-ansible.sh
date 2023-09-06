#!/bin/bash

sudo yum update -y
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable ansible2
sudo yum install -y ansible
sudo amazon-linux-extras install epel -y
