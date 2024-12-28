#!/bin/bash

echo "Waiting for postgres..."

while ! nc -z $POSTGRES_HOST 5432; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is up - executing command"

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start server
echo "Starting server..."
gunicorn ecom.wsgi:application --bind 0.0.0.0:8000