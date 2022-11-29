resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}