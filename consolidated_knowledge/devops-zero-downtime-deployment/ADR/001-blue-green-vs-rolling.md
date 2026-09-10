# Context
We need to deploy updates without dropping user connections (Zero-Downtime).

# Options Considered
1. **Rolling Updates:** Replace instances one by one. In native Docker Compose, this requires `--no-deps --build`.
2. **Blue/Green Deployment:** Stand up an entirely new identical stack (Green), test it, and then switch the Traefik router to point to Green.

# Decision
We will default to **Blue/Green Deployments** for major releases and **Rolling Updates** for minor, stateless API patches.

# Consequences
- **Positive:** Blue/Green allows exact pre-production validation on the live server and instant fallback.
- **Negative:** Blue/Green requires 2x the memory and CPU during the deployment window.
