# Disaster Recovery & Rollback

## 1. Failed Deployment Rollback
The deployment script incorporates automated disaster recovery logic for bad releases:
```bash
PREVIOUS_IMAGE=$(docker inspect --format "{{.Config.Image}}" app-container || echo "")
# ... deployment ...
if ! verify_health; then
  # Initiate rollback
  docker run -d --name app-container $PREVIOUS_IMAGE
  if ! verify_health; then
    exit 1 # Report rollback failure
  fi
fi
```
This logic attempts to revert to the previous state if a bad commit bypasses the CI gates. Note that it does not guarantee recovery; if the `PREVIOUS_IMAGE` is corrupt or unavailable, the rollback itself will fail and be reported to the pipeline.

## 2. Compromised Registry
If GHCR is compromised or goes offline, the `deployment-pipeline.yml` will fail to push. Existing deployments are unaffected because they rely on the local Docker daemon cache on the target host.

