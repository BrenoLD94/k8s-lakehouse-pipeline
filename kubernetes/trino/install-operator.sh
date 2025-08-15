helm repo add trino https://trinodb.github.io/charts

# helm repo update

helm install -f trino-helm-values.yaml trino-cluster trino/trino --namespace lakehouse --create-namespace --wait --timeout 15m 

kubectl port-forward svc/trino 8080:8080

# helm uninstall trino-cluster