output "cluster_id" {
  value = digitalocean_kubernetes_cluster.demo.id
}

output "cluster_name" {
  value = digitalocean_kubernetes_cluster.demo.name
}