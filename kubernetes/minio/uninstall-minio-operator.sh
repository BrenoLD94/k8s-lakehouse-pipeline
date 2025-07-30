#!/bin/bash
set -e

NAMESPACE="lakehouse" #"minio-operator"
RELEASE_NAME="minio-operator"

echo "🗑️ Uninstalling MinIO Operator..."
helm uninstall $RELEASE_NAME -n $NAMESPACE || true

echo "🗑️ Deleting namespace '$NAMESPACE'..."
minikube kubectl -- delete namespace $NAMESPACE --ignore-not-found

echo "✅ MinIO Operator uninstalled successfully!"
