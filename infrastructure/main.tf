provider "kubernetes" {
  host                   = var.k8s_host
  token                  = var.k8s_token
  cluster_ca_certificate = file(var.k8s_ca_cert)
}

resource "kubernetes_namespace" "django_app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "django_app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.django_app.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = var.docker_image
          name  = var.app_name

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "django_app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.django_app.metadata[0].name
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      protocol    = "TCP"
      port        = var.service_port
      target_port = var.container_port
    }

    type = var.service_type
  }
}
