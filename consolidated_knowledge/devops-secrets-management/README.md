# Secrets Management (`devops-secrets-management`)

## Overview
Standards for credential handling.

- No `.env` files in git. Only `.env.example`.
- Docker Secrets in Swarm/Compose instead of injected environment variables.
- GitHub Actions Encrypted Secrets for CI/CD.
