# Deployment and Rollback Strategy

## Context
We need a demonstrable target for CD that incorporates safety mechanics without claiming full Kubernetes infrastructure.

## Decision
We use a single-host SSH deployment strategy. The runner connects to the host, pulls the immutable artifact, and rotates the container. Crucially, it records the `PREVIOUS_IMAGE` SHA.

## Consequences
- If the post-deployment health check (`/health`) fails, the script explicitly halts, removes the defective container, and re-runs the `PREVIOUS_IMAGE`.
- A 15-second failure window exists during the transition, which is acceptable for this Engineering Lab but would necessitate Blue/Green or Rolling Updates via an orchestrator for true zero-downtime production.

