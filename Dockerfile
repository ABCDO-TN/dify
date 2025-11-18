#!/bin/bash
set -e

# This script is used to start the dify application in a single container.

# Run database migrations to ensure the schema is up-to-date
echo "Running database migrations..."
poetry run flask db upgrade

# Start the Gunicorn server in the background to serve the API
echo "Starting Gunicorn server..."
poetry run gunicorn --bind 0.0.0.0:7860 --workers 2 --threads 4 --timeout 300 'app:create_app()' &

# Start the Celery worker in the foreground.
# This keeps the container running and processes background tasks.
echo "Starting Celery worker..."
poetry run celery -A app.celery worker -l INFO
