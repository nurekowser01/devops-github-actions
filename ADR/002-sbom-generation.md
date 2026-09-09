# Context
Supply chain attacks (e.g., SolarWinds, log4j) require organizations to know exactly what libraries are inside their compiled containers.

# Decision
The pipeline uses Aqua Trivy and Syft to generate a Software Bill of Materials (SBOM) in SARIF format, which is uploaded directly to the GitHub Security tab.

# Consequences
- **Positive:** Automated compliance and instant visibility into zero-day vulnerabilities.
- **Negative:** Slightly increases CI build times.
