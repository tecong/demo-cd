#!/bin/bash

set -eux
kubectl create namespace argocd
kubectl config set-context --current --namespace=argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#use loadbalancer to expose API (other options: ingress, port forwarding, or keep it private)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'


VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

#install argocd client (for Mac could just use brew install argocd)
#sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
#sudo chmod +x /usr/local/bin/argocd

kubectl get svc

echo "Give ip of argocd service"
read IP

#this shows default admin password
echo "admin password is:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

argocd login $IP

#Smoke test installation - Create questbook app

argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

#uncomment to Create guestbook as helm deployment
#see https://github.com/argoproj/argocd-example-apps.git
#argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --helm-set replicaCount=2
