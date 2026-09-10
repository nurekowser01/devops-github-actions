# Pipeline & Application Testing

## Application Tests
We utilize Jest to verify the Express API:
* The `/health` endpoint responds accurately.
* Local runs yield `PASS tests/app.test.js`.

## Failure Scenarios (Expected Behaviors)
*Note: Runtime validation of deployment failures is BLOCKED pending a live SSH target.*

1. **CI Failure:** If Jest fails, the pipeline aborts. Deployment never triggers.
2. **Security Failure:** If Trivy detects a CVE, the job exits with code `1`. The artifact is discarded and never pushed to GHCR.
3. **Deployment Failure:** If the container starts but crashes due to a bad environment variable, the health verification loop `curl -s http://localhost:3000/health` times out.
4. **Rollback Behavior:** Upon health timeout, the deploy script queries the previously running container image, stops the defective container, and re-launches the previous known-good immutable image.

