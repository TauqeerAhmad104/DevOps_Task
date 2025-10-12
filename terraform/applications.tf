resource "kubernetes_manifest" "argocd_app_infrastructure" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "infrastructure"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/<your-github-username>/DevOps_Task.git"
        targetRevision = "main"
        path           = "infrastructure"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "infrastructure"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "argocd_app_applications" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "applications"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/<your-github-username>/DevOps_Task.git"
        targetRevision = "main"
        path           = "applications"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "applications"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  }
}
