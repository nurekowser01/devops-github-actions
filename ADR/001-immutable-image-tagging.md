# Immutable Image Tagging

## Context
Deploying from a `latest` tag creates an operational blind spot. If an incident occurs, `latest` does not identify which commit produced the defect, nor does it guarantee the image hasn't been overwritten.

## Decision
We enforce immutable image tagging using the Git commit SHA (`sha-abc123`).

## Consequences
- Every deployment uses a strictly verifiable artifact map back to source control.
- Rollbacks are deterministic (deploying the *exact* previous SHA).
- `latest` is intentionally avoided for deployment manifests.

