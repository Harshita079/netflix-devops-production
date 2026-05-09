#!/bin/bash

docker stop netflix-app || true

docker rm netflix-app || true

docker build -t netflix-clone .

docker run -d \
  --name netflix-app \
  -p 80:80 \
  netflix-clone