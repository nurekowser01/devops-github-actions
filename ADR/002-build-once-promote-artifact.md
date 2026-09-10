# Build Once, Promote Artifact

## Context
A pipeline might build an image for testing, scan it, and then run a separate job that rebuilds the image to push to the registry. 

## Problem
Rebuilding introduces the risk that the artifact scanned/tested is fundamentally different from the artifact published.

## Decision
We implement a strict single-artifact flow:
1. Build the local container artifact (`docker build`).
2. Scan that exact tagged artifact with Trivy.
3. Generate the SBOM with Syft against that exact artifact.
4. Promote/Push that *exact* artifact to GHCR (`docker push`).

## Consequences
- The workflow ensures that the published image is the identical artifact that passed the security scan.

