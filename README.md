# Real world DevOps with Nix

Setup

```shell
terraform apply
```

```shell
# Get the generated cluster name from the Terraform output
K8S_CLUSTER_NAME=$(terraform output --json | jq .k8s_cluster_name.value | tr -d \")
# Save the cluster config to the local ~/.kube
doctl kubernetes cluster kubeconfig save "${K8S_CLUSTER_NAME}"
# Get the context name
K8S_CONTEXT=$(terraform output --json | jq .k8s_context.value | tr -d \")
# Switch to the Digital Ocean cluster context
kubectx "${K8S_CONTEXT}"
```
