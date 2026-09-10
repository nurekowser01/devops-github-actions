const request = require("supertest");
const app = require("../src/app");

describe("API Endpoints", () => {
    it("should return healthy status on /health", async () => {
        const res = await request(app).get("/health");
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty("status", "healthy");
    });

    it("should return correct message on /", async () => {
        const res = await request(app).get("/");
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty("message", "CI/CD Pipeline Demo Active");
    });
});

