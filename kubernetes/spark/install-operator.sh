helm repo add --force-update spark-operator https://kubeflow.github.io/spark-operator

helm install spark-operator spark-operator/spark-operator --namespace lakehouse --create-namespace --set spark.jobNamespaces={lakehouse} --wait --timeout 15m 

minikube kubectl -- apply -f kubernetes/spark/spark-application-rbac.yaml