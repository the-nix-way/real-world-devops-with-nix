# Real world DevOps with Nix

This example project is meant to demonstrate the power of [Nix] in a DevOps
context. You can see this repo in action in my talk [Real world DevOps with
Nix][video], which was part of the [Summer of Nix][son] video series in 2022.

## Moving parts

* A very simple "TODOs" web service written in [Go] in
  [`cmd/todos/main.go`](./cmd/todos/main.go). This service is built to be
  deployed on a [Kubernetes] cluster running on [Digital Ocean][do].
* That cluster is stood up using a [Terraform] configuration in
  [`main.tf`](./main.tf) and [`terraform.tfvars`](./terraform.tfvars).
* The Kubernetes configuration in [`k8s/deployment.yaml`](./k8s/deployment.yaml)
  defines the Kubernetes [Deployment] for the service.
* The [GitHub Actions][actions] pipeline
  * Builds a [Docker] image for the TODOs service using [Nix]
  * Pushes the image to [Docker Hub][hub]
  * Updates the existing [Deployment] to use the new image
  * Restarts the [Deployment] to complete the upgrade

Some other things to note:

* The Kubernetes configuration for the Digital Ocean cluster, named
  `real-world-devops-with-nix`, is provided under the `KUBE_CONFIG` environment
  variable in the CI pipeline. To get that configuration as a base64 string:

  ```shell
  doctl kubernetes cluster kubeconfig show real-world-devops-with-nix | base64
  ```

[actions]: https://github.com/features/actions
[deployment]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment
[docker]: https://docker.com
[do]: https://digitalocean.com
[go]: https://golang.org
[hub]: https://hub.docker.com
[kubernetes]: https://kubernetes.io
[nix]: https://nixos.org
[son]: https://www.youtube.com/playlist?list=PLt4-_lkyRrOMWyp5G-m_d1wtTcbBaOxZk
[terraform]: https://terraform.io
[video]: https://www.youtube.com/watch?v=LjyQ7baj-KM&t=2809s
