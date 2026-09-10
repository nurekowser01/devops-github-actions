# ?? Production CI/CD Engineering (GitHub Actions)

![Status: Engineering Lab](https://img.shields.io/badge/Status-Engineering_Lab-blue)

## 1. Objective
Build a production-oriented GitHub Actions CI/CD demonstration showcasing how a containerized application safely moves from source code to deployment. This repository demonstrates strict artifact integrity: **Build once ? Verify ? Scan ? SBOM ? Publish immutable artifact ? Deploy exact artifact ? Verify ? Rollback if necessary.**

## 2. Pipeline Architecture
```mermaid
graph TD
    PR[Pull Request] -->|Triggers| CI[CI Validation]
    CI --> Lint
    CI --> Test
    CI --> BuildDryRun[Build Dry-Run]

    Main[Push to Main] -->|Triggers| Pipe[Deployment Pipeline]
    Pipe --> Gates[Quality Gates]
    Gates --> Build[Build Image Locally]
    Build --> Scan[Trivy Scan]
    Scan --> SBOM[Syft SBOM]
    SBOM --> Push[Push GHCR:sha-SHA]
    Push --> Deploy[SSH Deploy]
    Deploy --> Verify[Health Verify]
    Verify -->|Pass| Success
    Verify -->|Fail| Rollback[Rollback to Previous SHA]
```

## 3. Workflow Details
* **Pull Request (`pr-validation.yml`):** Runs `npm ci`, linting, unit testing, and a dry-run Docker build to prevent broken code from merging. It *never* deploys.
* **Main (`deployment-pipeline.yml`):** Executes the full promotion lifecycle. Fails if Trivy detects CRITICAL/HIGH vulnerabilities.
* **Image Tagging:** Uses immutable `sha-<commit>` tags.
* **Deployment:** Authenticates to a target host via SSH, pulls the exact SHA, rotates the container, and polls the `/health` endpoint. If the healthcheck fails, it automatically restarts the previous known-good immutable image.

## 4. Status & Limitations
**IMPLEMENTED:**
The workflows, security scans, SBOM generation, artifact integrity design, and rollback logic are fully implemented in YAML and shell logic.

**RUNTIME VALIDATION BLOCKED:**
*Note: Due to the Docker Engine and a dedicated external SSH target being unavailable in the local environment generating this documentation, end-to-end runtime validations of the deployment workflow are not fabricated.*

