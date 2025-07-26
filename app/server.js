const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

// Environment variables from sealed secrets
const dbPassword = process.env.DB_PASSWORD || "not-configured";
const apiKey = process.env.API_KEY || "not-configured";

app.get("/", (req, res) => {
  res.json({
    message: "Hello from AWS DevOps Pipeline!",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
    secrets_configured: {
      db_password: dbPassword !== "not-configured",
      api_key: apiKey !== "not-configured",
    },
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Only start the server if not in test environment
if (process.env.NODE_ENV !== "test") {
  const server = app.listen(port, () => {
    console.log(`Server running on port ${port}`);
    console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
  });

  // Export server for graceful shutdown
  module.exports = { app, server };
} else {
  module.exports = app;
}
