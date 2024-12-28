variable "k8s_host" {
  description = "The Kubernetes API server endpoint"
  type        = string
}

variable "k8s_token" {
  description = "The Kubernetes API token for authentication"
  type        = string
}

variable "k8s_ca_cert" {
  description = "Path to the Kubernetes CA certificate"
  type        = string
}

variable "namespace" {
  description = "The namespace for the application"
  type        = string
  default     = "django-app"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "my-django-app"
}

variable "docker_image" {
  description = "The Docker image for the application"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 1
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8000
}

variable "service_port" {
  description = "Port exposed by the Kubernetes service"
  type        = number
  default     = 80
}

variable "service_type" {
  description = "Type of Kubernetes service"
  type        = string
  default     = "LoadBalancer"
}
