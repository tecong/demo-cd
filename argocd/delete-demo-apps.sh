#!/bin/bash

for i in dev systemtest prod
do
	echo "Deleting app: demoapp-$i"
	argocd app delete demoapp-$i
done
