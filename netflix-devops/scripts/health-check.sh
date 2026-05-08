# health-check.sh

#!/bin/bash

echo "🔍 Running Application Health Check..."

STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" http://localhost)

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "✅ Application is Healthy!"
    exit 0
else
    echo "❌ Application Health Check Failed!"
    exit 1
fi