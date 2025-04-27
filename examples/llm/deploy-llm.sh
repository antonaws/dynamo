#!/bin/bash
set -e

# Set environment variables
export PROJECT_ROOT=$(pwd)
export KUBE_NS=dynamo-cloud
export DYNAMO_CLOUD="http://localhost:8000"

# Start port-forward in background
kubectl port-forward svc/dynamo-store 8000:80 -n $KUBE_NS &
PORT_FORWARD_PID=$!
sleep 5

# Build and deploy
cd $PROJECT_ROOT/examples/llm
DYNAMO_TAG=$(dynamo build graphs.agg:Frontend | grep "Successfully built" | awk '{print $NF}' | sed 's/\.$//')
echo "Built tag: $DYNAMO_TAG"

export DEPLOYMENT_NAME=llm-agg
dynamo deployment create $DYNAMO_TAG -n $DEPLOYMENT_NAME -f ./configs/agg.yaml -e $DYNAMO_CLOUD

# Wait for deployment
kubectl wait --for=condition=ready pod -l app=llm-frontend -n $KUBE_NS --timeout=300s

# Kill port-forward
kill $PORT_FORWARD_PID

echo "Deployment complete"
