#!/bin/bash
#login to ecr with jenkins user(so only we made sudo--pre-jenkin user to be sudo)
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 637423581881.dkr.ecr.ap-south-1.amazonaws.com

#build docker image
sudo docker build -t 637423581881.dkr.ecr.ap-south-1.amazonaws.com/static-app:$BUILD_NUMBER .

# push image to ecr
sudo docker push 637423581881.dkr.ecr.ap-south-1.amazonaws.com/static-app:$BUILD_NUMBER

#deploy
#get the kubeconfig (jenkins user ~/.kube/)
aws eks update-kubeconfig --region ap-south-1 --name education-eks-iR5hjJYc

cd deploy 
sed -i 's/tag/$BUILD_NUMBER/g' deploy.yaml 

kubectl create ns static
kubectl apply -f deploy.yaml -n static
kubectl apply -f svc.yaml -n static
kubectl apply -f ing.yaml -n static

sleep 10

kubectl get po -n static 
kubectl get svc -n static
kubectl get ing -n static 









