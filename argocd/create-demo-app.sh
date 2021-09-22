#!/bin/bash

#kubectl config use-context demo-test
#kubectl create namespace demo-dev
#kubectl create namespace demo-systemtest

#kubectl config use-context demo-prod
#kubectl create namespace demo-prod

REPO=https://github.com/tecong/demo-cd.git
REPO_PATH=demo-helm

argocd app create demoapp-dev --repo $REPO --revision main --path $REPO_PATH --dest-namespace demo-dev --dest-server https://kubernetes.default.svc --helm-set replicaCount=1 --values values.yaml

argocd app create demoapp-systemtest --repo $REPO --revision systemtest --path $REPO_PATH --dest-namespace demo-systemtest --dest-server https://kubernetes.default.svc --helm-set replicaCount=1 --values values-test.yaml

argocd app create demoapp-prod --repo $REPO --revision production --path $REPO_PATH --dest-namespace demo-prod --dest-server https://demoprod.svc.dev.teco.tieto1.1-4.fi.teco.online:8443 --helm-set replicaCount=2 --values values-production.yaml
