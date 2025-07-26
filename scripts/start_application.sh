#!/bin/bash

# Navigate to application directory
cd /home/ec2-user/app

# Install dependencies
npm install

# Start the application using PM2
npm install -g pm2
pm2 start server.js --name "nodejs-app"
pm2 startup
pm2 save

echo "Application started successfully"
