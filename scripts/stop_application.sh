#!/bin/bash

# Stop the application
pm2 stop nodejs-app || true
pm2 delete nodejs-app || true

echo "Application stopped successfully"
