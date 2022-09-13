// Root manifest
terraform {
  required_version = "1.2.9"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.22.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

// Providers
provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.devops.endpoint
  token = data.digitalocean_kubernetes_cluster.devops.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.devops.kube_config[0].cluster_ca_certificate
  )
}

// Variables
variable "do_token" {
  type = string
}

variable "k8s_cluster_name" {
  type = string
}

variable "k8s_num_nodes" {
  type = number
}

variable "k8s_region" {
  type = string
}

variable "k8s_worker_size" {
  type = string
}

// Data
data "digitalocean_kubernetes_versions" "current" {
  version_prefix = "1.23"
}

// Output
output "k8s_cluster_name" {
  value = digitalocean_kubernetes_cluster.devops.name
}

output "k8s_context" {
  value = "do-${var.k8s_region}-${digitalocean_kubernetes_cluster.devops.name}"
}

// Resources
resource "digitalocean_kubernetes_cluster" "devops" {
  name    = var.k8s_cluster_name
  region  = var.k8s_region
  version = data.digitalocean_kubernetes_versions.current.latest_version
  node_pool {
    name       = "default"
    size       = var.k8s_worker_size
    node_count = var.k8s_num_nodes
  }
}
