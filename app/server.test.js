const request = require("supertest");
const app = require("./server");

describe("Server", () => {
  test("GET / should return welcome message", async () => {
    const response = await request(app).get("/");
    expect(response.status).toBe(200);
    expect(response.body.message).toBe("Hello from AWS DevOps Pipeline!");
    expect(response.body.environment).toBe("test");
  });

  test("GET /health should return healthy status", async () => {
    const response = await request(app).get("/health");
    expect(response.status).toBe(200);
    expect(response.body.status).toBe("healthy");
    expect(response.body).toHaveProperty("timestamp");
    expect(response.body).toHaveProperty("uptime");
  });
});
