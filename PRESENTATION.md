# Presentation

Some pointers for me in case I get lost.

```shell
# Switch to minikube context
kubectx minikube

# Delete k8s resources
kubectl delete -f ./k8s.yaml

# Spin up k8s deployment
kubectl apply -f ./k8s.yaml

# See deployment image
kubectl get deployments.apps/todos-deployment --output=json | jq '.spec.template.spec.containers[0].image'

# Watch pods
kubectl get pods --watch

# Port forward
kubectl port-forward deployments.apps/todos-deployment 8080:8080

# Re-deploy
./deploy.sh
```
