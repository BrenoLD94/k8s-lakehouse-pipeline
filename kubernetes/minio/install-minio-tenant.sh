#!/bin/bash
set -e

NAMESPACE="lakehouse" #"minio-tenant"
RELEASE_NAME="lakehouse-minio"
VALUES_FILE="values.yaml"
STATEFULSET="${RELEASE_NAME}-pool-0"

echo "🚀 Installing MinIO Tenant '$RELEASE_NAME' in namespace '$NAMESPACE'..."
helm install $RELEASE_NAME minio-operator/tenant \
  --namespace $NAMESPACE \
  --create-namespace \
  --values $VALUES_FILE

echo "⏳ Waiting for StatefulSet '$STATEFULSET' to be created..."
# Wait until the StatefulSet exists
for i in {1..30}; do
  if minikube kubectl -- get statefulset $STATEFULSET -n $NAMESPACE &> /dev/null; then
    echo "✅ StatefulSet '$STATEFULSET' found!"
    break
  fi
  echo "⏳ Waiting for StatefulSet... ($i/30)"
  sleep 5
done

echo "⏳ Waiting for MinIO Tenant pods to be ready..."
minikube kubectl -- rollout status statefulset/$STATEFULSET -n $NAMESPACE

echo "✅ MinIO Tenant installed successfully!"
minikube kubectl -- get pods,svc -n $NAMESPACE

echo ""
echo "🔹 To access the MinIO Console, run:"
echo "kubectl port-forward svc/${RELEASE_NAME}-console 9443:9443 -n $NAMESPACE"
echo "Then open https://localhost:9443 in your browser."
