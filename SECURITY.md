# CI/CD Security Controls

The workflow applies least-privilege permissions and introduces controls intended to reduce supply-chain and deployment risks.

## 1. Workflow Permissions
The workflows explicitly restrict GitHub token scopes at the job level. By default, the workflow only receives `contents: read`. Only the `build-scan-publish` job receives `packages: write`, ensuring that code validation jobs cannot maliciously push artifacts.

## 2. Secret Handling
Real credentials are never committed. Deployment connects using GitHub Secrets (`DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`). The SSH script securely passes a separate `DEPLOY_GHCR_TOKEN` into the remote host to authenticate `docker pull` without exposing the token in process arguments.

## 3. Vulnerability Scanning & SBOM
* **Trivy:** Integrated into the pipeline to block deployments if `CRITICAL` or `HIGH` vulnerabilities are found in the OS or application libraries.
* **Syft:** Generates an SPDX JSON Software Bill of Materials archived as a pipeline artifact, providing a manifest of contents inside the image.

## 4. Immutable Artifacts
Images are published with their Git commit SHA. This prevents the "latest" mutation attack where an adversary overwrites a rolling tag in the registry.

## 5. Action Pinning Limitation
While immutable commit SHA pinning is preferred for third-party actions, this lab currently utilizes semantic version tags (e.g., `@v4.1.1`). Because local verification of third-party SHAs is blocked in the host environment, semantic tags are used to avoid fabricating unverified SHA values.

