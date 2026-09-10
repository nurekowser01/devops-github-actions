# CI/CD Security Controls

The workflow applies least-privilege permissions and introduces controls intended to reduce supply-chain and deployment risks.

## 1. Workflow Permissions
The workflows explicitly restrict GitHub token scopes:
```yaml
permissions:
  contents: read
  packages: write
```
This ensures a compromised workflow cannot modify repository code or issue releases, granting only the ability to publish the container artifact.

## 2. Secret Handling
Real credentials are never committed. Deployment connects using GitHub Secrets (`DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`). `GITHUB_TOKEN` is used natively for GHCR authentication.

## 3. Vulnerability Scanning & SBOM
* **Trivy:** Integrated into the pipeline to block deployments if `CRITICAL` or `HIGH` vulnerabilities are found in the OS or application libraries.
* **Syft:** Generates an SPDX JSON Software Bill of Materials archived as a pipeline artifact, providing a cryptographically verifiable manifest of everything inside the image.

## 4. Immutable Artifacts
Images are published with their Git commit SHA. This prevents the "latest" mutation attack where an adversary overwrites a rolling tag in the registry.

