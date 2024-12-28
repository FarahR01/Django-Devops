output "namespace" {
  description = "The namespace of the deployed application"
  value       = kubernetes_namespace.django_app.metadata[0].name
}

output "service_url" {
  description = "The URL of the Django application"
  value       = kubernetes_service.django_app.metadata[0].name
}
output "service_external_url" {
  description = "The external URL of the Django application (for LoadBalancer services)"
  value       = "http://${kubernetes_service.django_app.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.service_port}"
}

output "loadbalancer_ip" {
  description = "External IP of the LoadBalancer"
  value       = kubernetes_service.django_app.status[0].load_balancer[0].ingress[0].ip
}

