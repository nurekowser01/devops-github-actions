const express = require("express");
const app = express();

app.get("/health", (req, res) => {
    res.status(200).json({ status: "healthy", version: process.env.COMMIT_SHA || "unknown" });
});

app.get("/", (req, res) => {
    res.json({ message: "CI/CD Pipeline Demo Active" });
});

module.exports = app;

