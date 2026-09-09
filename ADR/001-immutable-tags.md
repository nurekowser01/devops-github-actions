# Context
Deploying Docker images tagged as `:latest` causes race conditions and makes rollbacks extremely difficult, as `latest` points to different hashes over time.

# Decision
We tag all production images with the exact Git SHA (`sha-${{ github.sha }}`) of the commit that triggered the pipeline.

# Consequences
- **Positive:** 100% guarantee that the code tested in staging is the exact bytecode deployed to production. Rollbacks are instant.
- **Negative:** The registry fills up quickly with unique tags, requiring automated pruning (implemented in `devops-container-registry`).
