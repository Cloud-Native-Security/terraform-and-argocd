terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_kubernetes_cluster" "demo" {
  name = var.cluster_name
}

provider "kubernetes" {
  host             = data.digitalocean_kubernetes_cluster.demo.endpoint
  token            = data.digitalocean_kubernetes_cluster.demo.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.demo.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.demo.endpoint
    token = data.digitalocean_kubernetes_cluster.demo.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.demo.kube_config[0].cluster_ca_certificate
    )
  }
}
