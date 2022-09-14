# Real world DevOps with Nix

This example project is meant to demonstrate the power of [Nix] in a DevOps
context. The main moving parts:

* A simple "TODOs" web service written in [Go] in
  [`cmd/todos/main.go`](./cmd/todos/main.go). This service is built to be
  deployed on a cluster [Kubernetes] on [Digital Ocean][do].
* That cluster is stood up using a [Terraform] configuration in
  [`main.tf`](./main.tf) and [`terraform.tfvars`](./terraform.tfvars).
* The Kubernetes configuration in [`k8s/deployment.yaml`](./k8s/deployment.yaml)
  defines the Kubernetes [Deployment] for the service.
* The [GitHub Actions][actions] pipeline does the following:
  * Builds a [Docker] image for the TODOs service using [Nix] (with caching
    provided by [Cachix]).
  * Pushes the image to [Docker Hub][hub]
  * Updates the existing deployment to use the new image
  * Restarts the deployment to complete the upgrade

Some other things to note:

* The Kubernetes configuration for the Digital Ocean cluster, named
  `real-world-devops-with-nix`, is provided under the `KUBE_CONFIG` environment
  variable in the CI pipeline. To get that configuration as a base64 string:

  ```shell
  doctl kubernetes cluster kubeconfig show real-world-devops-with-nix | base64
  ```

[actions]: https://github.com/features/actions
[cachix]: https://cachix.org
[deployment]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment
[docker]: https://docker.com
[do]: https://digitalocean.com
[go]: https://golang.org
[hub]: https://hub.docker.com
[kubernetes]: https://kubernetes.io
[nix]: https://nixos.org
[terraform]: https://terraform.io
