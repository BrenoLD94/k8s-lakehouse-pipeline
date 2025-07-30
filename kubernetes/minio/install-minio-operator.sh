#!/bin/bash
set -e

NAMESPACE="lakehouse" #"minio-operator"
RELEASE_NAME="minio-operator"

echo "🚀 Installing MinIO Operator in namespace '$NAMESPACE'..."
helm install $RELEASE_NAME minio-operator/operator \
  --namespace $NAMESPACE \
  --create-namespace

echo "⏳ Waiting for MinIO Operator pods to be ready..."
minikube kubectl -- rollout status deployment/minio-operator -n $NAMESPACE

echo "✅ MinIO Operator installed successfully!"
minikube kubectl -- get pods -n $NAMESPACE
