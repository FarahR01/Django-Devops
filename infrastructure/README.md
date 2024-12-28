# Terraform Infrastructure for Django Application Deployment

This repository contains Terraform configurations for deploying a Django application on Kubernetes, providing automated infrastructure setup and management.

## Why Terraform?

Terraform was chosen for this infrastructure deployment for several key reasons:

- **Infrastructure as Code (IaC)**: Enables version control and reproducible deployments
- **Declarative Configuration**: Defines the desired state of infrastructure, reducing human error
- **State Management**: Tracks and maintains infrastructure state consistently
- **Provider Ecosystem**: Rich support for various cloud providers and Kubernetes
- **Automation**: Streamlines deployment process and reduces manual intervention

## Objectives

1. Automate Django application deployment on Kubernetes
2. Ensure high availability through multiple replicas
3. Provide external access via LoadBalancer
4. Maintain consistent deployment across environments
5. Enable easy scaling and management of infrastructure

## Infrastructure Components

### 1. Kubernetes Namespace

Creates an isolated environment for the Django application:

```hcl
resource "kubernetes_namespace" "django_app" {
  metadata {
    name = "django-namespace"
  }
}
```

### 2. Kubernetes Deployment

Manages the Django application pods:

```hcl
resource "kubernetes_deployment" "django_app" {
  metadata {
    name      = "my-django-app"
    namespace = kubernetes_namespace.django_app.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        "app" = "my-django-app"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "my-django-app"
        }
      }
      spec {
        container {
          name  = "my-django-app"
          image = "farahr/my-django-app"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}
```

### 3. Kubernetes Service (LoadBalancer)

Exposes the application externally:

```hcl
resource "kubernetes_service" "django_app" {
  metadata {
    name      = "my-django-app"
    namespace = kubernetes_namespace.django_app.metadata[0].name
  }
  spec {
    type = "LoadBalancer"
    selector = {
      "app" = "my-django-app"
    }
    port {
      port        = 80
      target_port = 8000
    }
  }
}
```

## LoadBalancer Service Benefits

The LoadBalancer service type offers several advantages:

- External IP assignment for public access
- Automatic load distribution across pods
- Native integration with cloud providers' load balancers
- Built-in health checking and failover
- Simplified DNS and SSL management

## Prerequisites

- Terraform v0.12+
- kubectl command-line tool
- Access to a Kubernetes cluster
- Required credentials (tokens, certificates)

## Deployment Process

1. Initialize Terraform:
```bash
terraform init
```

2. Review planned changes:
```bash
terraform plan -var-file="terraform.tfvars"
```

3. Apply configuration:
```bash
terraform apply -var-file="terraform.tfvars"
```

## Configuration Variables

Required variables in `terraform.tfvars`:

```hcl
kubernetes_cluster_host     = "https://your-cluster-endpoint"
kubernetes_cluster_token    = "your-cluster-token"
kubernetes_cluster_ca_cert  = "base64-encoded-ca-cert"
```

## Outputs

After successful deployment, Terraform provides:

```hcl
output "loadbalancer_ip" {
  value = kubernetes_service.django_app.load_balancer_ingress[0].ip
}

output "namespace" {
  value = kubernetes_namespace.django_app.metadata[0].name
}

output "service_external_url" {
  value = "http://${kubernetes_service.django_app.metadata[0].name}.${kubernetes_namespace.django_app.metadata[0].name}.svc.cluster.local:80"
}

output "service_url" {
  value = kubernetes_service.django_app.metadata[0].name
}
```

## Verification and Testing

1. Check deployment status:
```bash
kubectl get deployments -n django-namespace
```

2. Verify service creation:
```bash
kubectl get svc -n django-namespace
```

3. Test application access:
```bash
curl http://<LoadBalancer_IP>:80
```

## Troubleshooting

Common issues and solutions:

1. **Namespace Conflicts**
   - Delete existing namespace: `kubectl delete namespace django-namespace`
   - Import into Terraform: `terraform import kubernetes_namespace.django_app django-namespace`

2. **Permission Issues**
   - Verify cluster role bindings
   - Check service account permissions
   - Ensure proper kubeconfig context

## Maintenance

- Regular `terraform plan` to check for drift
- Update image tags in deployment as needed
- Monitor LoadBalancer costs
- Review and adjust replica count based on traffic