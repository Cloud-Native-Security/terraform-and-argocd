resource "helm_release" "argocd" {
  name       = "argocd-helm"
  namespace  = kubernetes_namespace.argocd_namespace.metadata.0.name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  write_kubeconfig      = true
  config_output_path    = "/."

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/do-loadbalancer-name"
    value = format("%s-nginx-ingress", var.cluster_name)
  }
}