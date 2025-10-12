# Argo CD Application: Infrastructure
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
        repoURL        = "https://github.com/TauqeerAhmad104/DevOps_Task.git"
        targetRevision = "main"
        path           = "infrastructure/infra-chart"
        helm           = {}
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "infrastructure"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

# Argo CD Application: Applications (frontend + backend)
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
        repoURL        = "https://github.com/TauqeerAhmad104/DevOps_Task.git"
        targetRevision = "main"
        path           = "applications/app-chart"
        helm           = {}
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "applications"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}
