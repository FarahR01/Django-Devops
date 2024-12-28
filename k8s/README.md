# Django E-commerce Application - Kubernetes Deployment

## Overview
Kubernetes configuration for deploying a Django e-commerce application with PostgreSQL database, providing scalability and maintainability.

## Prerequisites
- Kubernetes cluster
- kubectl configured
- Docker image (farahr/my-django-app)
- Nginx Ingress Controller

## Directory Structure
```
k8s/
├── django-configmap.yaml
├── django-deployment.yaml
├── django-ingress.yaml
├── django-secret.yaml
├── django-service.yaml
├── postgres-deployment.yaml
├── postgres-pvc.yaml
└── postgres-service.yaml
```

## Components

### 1. Django ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: django-configmap
data:
  DEBUG: "True"
  ALLOWED_HOSTS: "localhost,127.0.0.1,djangotest.com"
  CSRF_TRUSTED_ORIGINS: "https://djangotest.com"
```

### 2. Django Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: django-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: django
  template:
    metadata:
      labels:
        app: django
    spec:
      containers:
        - name: django
          image: farahr/my-django-app
```

### 3. PostgreSQL Setup
- PVC with 5GB storage
- PostgreSQL 14 deployment
- Headless service

## Deployment Steps

1. Create Secrets:
```bash
kubectl apply -f django-secret.yaml
```

2. Create ConfigMap:
```bash
kubectl apply -f django-configmap.yaml
```

3. Deploy PostgreSQL:
```bash
kubectl apply -f postgres-pvc.yaml
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
```

4. Deploy Django:
```bash
kubectl apply -f django-deployment.yaml
kubectl apply -f django-service.yaml
kubectl apply -f django-ingress.yaml
```

## Environment Configuration

### Required Secrets (Base64 Encoded)
- `SECRET_KEY`: Django secret key
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `PAYPAL_RECEIVER_EMAIL`: PayPal email

### ConfigMap Settings
- `DEBUG`: Development mode
- `ALLOWED_HOSTS`: Allowed domains
- `CSRF_TRUSTED_ORIGINS`: CSRF trusted origins

## Verification

1. Check Deployments:
```bash
kubectl get deployments
```

2. Check Pods:
```bash
kubectl get pods
```

3. Check Services:
```bash
kubectl get services
```

4. Check Ingress:
```bash
kubectl get ingress
```

## Scaling

Scale Django deployment:
```bash
kubectl scale deployment django-deployment --replicas=3
```

## Database Management

1. Access PostgreSQL:
```bash
kubectl exec -it <postgres-pod> -- psql -U postgres
```

2. Backup Database:
```bash
kubectl exec -it <postgres-pod> -- pg_dump -U postgres > backup.sql
```

## Troubleshooting

1. View Django Logs:
```bash
kubectl logs -f deployment/django-deployment
```

2. Check Pod Status:
```bash
kubectl describe pod <pod-name>
```

3. Test Database Connection:
```bash
kubectl exec -it <django-pod> -- python manage.py dbshell
```

## Monitoring

1. Resource Usage:
```bash
kubectl top pods
kubectl top nodes
```

2. Service Status:
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Security Best Practices

1. Use Secrets for sensitive data
2. Enable network policies
3. Regular security updates
4. Use resource limits
5. Implement RBAC

## Maintenance

1. Update Application:
```bash
kubectl set image deployment/django-deployment django=farahr/my-django-app:new-tag
```

2. Rolling Restart:
```bash
kubectl rollout restart deployment django-deployment
```

3. View Rollout Status:
```bash
kubectl rollout status deployment django-deployment
```

## Limitations
1. Single PostgreSQL instance
2. Local storage for database
3. Basic ingress configuration
4. No automatic backup solution

## Recommendations
1. Implement backup solution
2. Add monitoring tools
3. Configure horizontal pod autoscaling
4. Set up CI/CD pipeline
5. Add health checks