# Build Once, Promote Artifact

## Context
A pipeline might build an image for testing, scan it, and then run a separate job that rebuilds the image to push to the registry. 

## Problem
Rebuilding introduces the risk that the artifact scanned/tested is fundamentally different from the artifact published (e.g., if a third-party dependency updates in the 60 seconds between jobs).

## Decision
We implement a single linear flow in GitHub Actions:
1. Build local container artifact (`load: true`).
2. Scan the exact artifact with Trivy.
3. Generate SBOM with Syft.
4. Promote/Push that *exact* artifact to the GitHub Container Registry.

## Consequences
- Zero drift between what is verified and what is shipped.

