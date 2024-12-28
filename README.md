# Django E-commerce Application - Docker Setup

## Project Overview

A Django-based e-commerce application containerized using Docker for consistent development and deployment environments.

## Prerequisites

- Docker installed
- Docker Compose installed
- Python 3.10+
- PostgreSQL 14+

## Docker Configuration

### Dockerfile

```dockerfile
FROM python:3.10-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install gunicorn

# Copy project files
COPY . /app

# Create directory for static files
RUN mkdir -p /app/staticfiles

EXPOSE 8000

# Use entrypoint script
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "ecom.wsgi:application"]
```

## Project Structure

```
├── Dockerfile
├── requirements.txt
├── manage.py
├── ecom/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── staticfiles/
```

## Building and Running

1. Build the Docker image:

```bash
docker build -t ecommerce-django .
```

2. Run the container:

```bash
docker run -p 8000:8000 ecommerce-django
```

## Environment Variables

Configure these environment variables for the container:

- `DEBUG`: Set to "True" for development
- `SECRET_KEY`: Django secret key
- `ALLOWED_HOSTS`: Comma-separated list of allowed hosts
- `DB_NAME`: PostgreSQL database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `PAYPAL_RECEIVER_EMAIL`: PayPal business email

## Development Workflow

1. Make changes to your code locally
2. Rebuild the Docker image:

```bash
docker build -t ecommerce-django .
```

3. Push to Docker Hub:

```bash
docker tag ecommerce-django farahr/my-django-app
docker push farahr/my-django-app
```

## Testing

Run tests inside the container:

```bash
docker run ecommerce-django python manage.py test
```

## Static Files

Static files are collected to `/app/staticfiles/`. To collect static files:

```bash
docker run ecommerce-django python manage.py collectstatic --noinput
```

## Troubleshooting

1. Database connection issues:

```bash
docker run -it ecommerce-django python manage.py dbshell
```

2. View container logs:

```bash
docker logs <container_id>
```

3. Access container shell:

```bash
docker exec -it <container_id> /bin/bash
```

## Best Practices

1. Use `.dockerignore` to exclude unnecessary files
2. Keep image size minimal by using multi-stage builds
3. Don't store sensitive data in the image
4. Regularly update base images and dependencies
5. Use specific version tags for dependencies

## Security Considerations

1. Don't run as root user
2. Use environment variables for sensitive data
3. Regularly scan for vulnerabilities
4. Keep dependencies updated
5. Use secure base images
# Django-Devops
