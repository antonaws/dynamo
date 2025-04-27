#!/bin/bash
set -e

# Set environment variables
export PROJECT_ROOT=$(pwd)
export DOCKER_SERVER="058264135704.dkr.ecr.us-east-1.amazonaws.com"
export IMAGE_TAG="latest"
export NAMESPACE="dynamo-cloud"
export DYNAMO_INGRESS_SUFFIX="dynamo-cloud.com"

# Create namespace
echo "Creating namespace..."
kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

# Create ECR pull secret
echo "Creating ECR pull secret..."
aws ecr get-login-password --region us-east-1 | \
kubectl create secret docker-registry docker-imagepullsecret \
  --docker-server=$DOCKER_SERVER \
  --docker-username=AWS \
  --docker-password-stdin \
  --namespace=$NAMESPACE

# Deploy Dynamo Cloud
echo "Deploying Dynamo Cloud..."
cd $PROJECT_ROOT/deploy/dynamo/helm
./deploy.sh

# Wait for core services
echo "Waiting for core services..."
kubectl wait --for=condition=ready pod -l app=dynamo-api-store -n $NAMESPACE --timeout=300s
kubectl wait --for=condition=ready pod -l app=dynamo-operator -n $NAMESPACE --timeout=300s

echo "Installation complete"
