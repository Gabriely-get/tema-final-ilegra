#!/bin/bash

minikube delete
minikube start --static-ip 192.168.49.2
minikube addons enable ingress

sleep 60s

minikube kubectl -- apply -f /home/ec2-user/minikube/elasticsearch.yaml
minikube kubectl -- apply -f /home/ec2-user/minikube/elasticsearch-ingress.yaml

sudo systemctl enable nginx
sudo systemctl restart nginx