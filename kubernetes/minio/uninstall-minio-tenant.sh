#!/bin/bash
set -e

NAMESPACE="lakehouse" #"minio-tenant"
RELEASE_NAME="lakehouse-minio"

echo "🗑️ Uninstalling MinIO Tenant '$RELEASE_NAME'..."
helm uninstall $RELEASE_NAME -n $NAMESPACE || true

echo "🗑️ Deleting namespace '$NAMESPACE'..."
minikube kubectl -- delete namespace $NAMESPACE --ignore-not-found

echo "✅ MinIO Tenant uninstalled successfully!"
