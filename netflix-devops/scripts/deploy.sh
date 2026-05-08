# deploy.sh

#!/bin/bash

echo "🚀 Starting Deployment..."

# Stop old container if exists
docker stop netflix-app-container || true

# Remove old container
docker rm netflix-app-container || true

# Remove old image
docker rmi netflix-app || true

# Build fresh image
docker build -t netflix-app -f docker/Dockerfile .

# Run new container
docker run -d \
  --name netflix-app-container \
  -p 80:80 \
  netflix-app

echo "✅ Deployment Completed Successfully!"