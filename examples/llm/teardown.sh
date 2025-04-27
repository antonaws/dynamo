#!/bin/bash

echo "Deleting Dynamo deployments..."
kubectl delete dynamodeployments.nvidia.com --all -n dynamo-cloud

echo "Deleting Helm release..."
helm uninstall dynamo-cloud -n dynamo-cloud

echo "Deleting namespace..."
kubectl delete namespace dynamo-cloud

echo "Deleting CRDs..."
kubectl delete crd dynamodeployments.nvidia.com

echo "Deleting RBAC..."
kubectl delete clusterrole dynamo-deployment-cluster-role
kubectl delete clusterrolebinding dynamo-deployment-cluster-rolebinding

echo "Cleaning up PVCs..."
kubectl delete pvc --all -n dynamo-cloud

echo "Waiting for namespace deletion..."
kubectl wait --for=delete namespace/dynamo-cloud --timeout=300s

echo "Teardown complete"
