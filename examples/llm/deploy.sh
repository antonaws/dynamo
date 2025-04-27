#!/bin/bash
set -e

echo "Applying CRD..."
kubectl apply -f dynamo-crd.yaml

echo "Applying RBAC..."
kubectl apply -f rbac.yaml
kubectl apply -f cluster-rbac.yaml

echo "Verifying permissions..."
kubectl auth can-i create dynamodeployments.nvidia.com --as=system:serviceaccount:dynamo-cloud:dynamo-cloud-dynamo-api-store -n dynamo-cloud

echo "Starting port-forward..."
kubectl port-forward svc/dynamo-store 8000:80 -n dynamo-cloud &
PORT_FORWARD_PID=$!

sleep 5

echo "Applying deployment..."
kubectl apply -f llm-deployment.yaml

echo "Checking deployment status..."
kubectl get dynamodeployments.nvidia.com -n dynamo-cloud
kubectl describe dynamodeployments.nvidia.com llm-agg -n dynamo-cloud

echo "Checking operator logs..."
kubectl logs -n dynamo-cloud -l control-plane=controller-manager -c manager --tail=50

echo "Waiting for deployment..."
kubectl wait --for=condition=available deployment -l app=llm -n dynamo-cloud --timeout=300s || true

echo "Current state:"
kubectl get all -n dynamo-cloud -l app=llm

# Kill port-forward
kill $PORT_FORWARD_PID

echo "Deployment complete"
