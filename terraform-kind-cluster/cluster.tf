resource "kind_cluster" "default" {
    name = "demo-cluster"
    wait_for_ready = "true"
    kubeconfig = "true"
    # node_image = "kindest/node:v1.16.1"
}