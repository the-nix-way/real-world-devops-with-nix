# Real world DevOps with Nix

## Local setup

```shell
# Spin up the Kubernetes cluster in Digital Ocean
terraform apply
# Get the generated cluster name from the Terraform output
K8S_CLUSTER_NAME=$(terraform output --json | jq .k8s_cluster_name.value | tr -d \")
# Save the cluster config to the local ~/.kube
doctl kubernetes cluster kubeconfig save "${K8S_CLUSTER_NAME}"
# Get the context name
K8S_CONTEXT=$(terraform output --json | jq .k8s_context.value | tr -d \")
# Switch to the Digital Ocean cluster context
kubectx "${K8S_CONTEXT}"
# Get the Kubernetes config from the cluster (and copy into GitHub Actions environment)
doctl kubernetes cluster kubeconfig show "${K8S_CLUSTER_NAME}"
# Set up the deployment
kubectl apply -f ./k8s/deployment.yaml
# Port forward
kubectl port-forward deployments.apps/todos-deployment 8080:8080
# Get current image
kubectl get deployments.apps/todos-deployment --output=json | jq '.spec.template.spec.containers[0].image'
```
