#!/bin/bash

# Script para iniciar todos os túneis de port-forward para os serviços do Lakehouse.
# Use Ctrl+C para encerrar todos os túneis de uma vez.

echo "Iniciando port-forward para os serviços do namespace 'lakehouse'..."

# --- MinIO ---
# Expõe a UI do MinIO na porta 9001
echo "Encaminhando MinIO UI -> http://localhost:9001"
minikube kubectl -- port-forward --namespace lakehouse svc/minio-service 9001:9001 &

# --- Spark ---
# Expõe a UI do Spark Master na porta 8088
echo "Encaminhando Spark Master UI -> http://localhost:8080"
minikube kubectl -- port-forward --namespace lakehouse svc/spark-master-svc 8080:80 &

# --- postgres ---
# Expõe uma porta do postgres 5432
echo "Encaminhando porta do PostgreSQL -> localhost:5432 (use com um cliente de BD)"
minikube kubectl -- port-forward --namespace lakehouse svc/postgres-postgresql 5432:5432 &

echo "--------------------------------------------------------"
echo "Túneis iniciados em segundo plano."
echo "Pressione Ctrl+C neste terminal para encerrá-los todos."
echo "--------------------------------------------------------"

# Mantém o script rodando para que o Ctrl+C funcione para todos.
wait