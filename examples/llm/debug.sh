#!/bin/bash

echo "Checking CRD status..."
kubectl get crd dynamodeployments.nvidia.com -o yaml

echo -e "\nChecking operator logs..."
kubectl logs -n dynamo-cloud -l control-plane=controller-manager -c manager --tail=50

echo -e "\nChecking deployment status..."
kubectl get dynamodeployments.nvidia.com -n dynamo-cloud -o yaml

echo -e "\nChecking events..."
kubectl get events -n dynamo-cloud --sort-by='.metadata.creationTimestamp'

echo -e "\nChecking API store logs..."
kubectl logs -n dynamo-cloud -l app=dynamo-api-store --tail=50
