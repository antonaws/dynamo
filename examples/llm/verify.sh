#!/bin/bash

echo "Checking core services..."
kubectl get pods -n dynamo-cloud

echo -e "\nChecking services..."
kubectl get svc -n dynamo-cloud

echo -e "\nChecking LLM deployment..."
kubectl get pods -n dynamo-cloud -l app=llm-frontend

echo -e "\nChecking logs..."
kubectl logs -n dynamo-cloud -l app=llm-frontend --tail=20
