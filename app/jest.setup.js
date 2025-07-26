// Jest setup file for proper cleanup
// Set test environment
process.env.NODE_ENV = "test";

// Global test timeout
jest.setTimeout(10000);

// Clean up after all tests
afterAll(() => {
  // Force garbage collection if available
  if (global.gc) {
    global.gc();
  }
});
