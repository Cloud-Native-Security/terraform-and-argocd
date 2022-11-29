resource "digitalocean_kubernetes_cluster" "demo" {
  name   = "demo"
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}