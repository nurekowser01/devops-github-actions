# CI/CD Pipeline Architecture

## The Workflows
1. **`pr-validation.yml`**: Protects the `main` branch. It ensures dependency locking (`npm ci`), code quality (ESLint), business logic integrity (Jest), and Dockerfile validity (Buildx cache-only run).
2. **`deployment-pipeline.yml`**: The release train.

## Action & Dependency Pinning
Supply chain security starts at the pipeline. All third-party GitHub Actions (e.g., `actions/checkout@v4.1.1`, `docker/login-action@v3.0.0`) are explicitly versioned. Application dependencies are resolved deterministically using `package-lock.json`.

## Artifact Integrity
We do not build the image twice. The pipeline builds the image into the local runner daemon, subjects that exact binary to Trivy and Syft, and only pushes it to GHCR if all gates pass.

