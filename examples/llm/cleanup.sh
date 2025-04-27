#!/bin/bash

# Delete RBAC configurations
kubectl delete -f rbac.yaml
kubectl delete -f cluster-rbac.yaml

# Delete deployment
kubectl delete deployment -n dynamo-cloud llm-frontend

# Delete service account
kubectl delete serviceaccount -n dynamo-cloud dynamo-deployer
