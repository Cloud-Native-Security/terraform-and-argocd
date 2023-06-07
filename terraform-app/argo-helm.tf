resource "helm_release" "argocd" {
  name       = "argocd-helm"
  namespace  = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  # depends_on = [kubernetes_namespace.argocd_namespace]
}