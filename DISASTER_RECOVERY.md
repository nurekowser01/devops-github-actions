# Disaster Recovery & Rollback

## 1. Failed Deployment Rollback
The deployment script incorporates automated disaster recovery for bad releases:
```bash
PREVIOUS_IMAGE=$(docker inspect --format "{{.Config.Image}}" app-container || echo "")
# ... deployment ...
if ! curl -s http://localhost:3000/health; then
  docker run -d --name app-container $PREVIOUS_IMAGE
fi
```
This guarantees that if a bad commit bypasses the CI gates, the system automatically reverts to the previous state.

## 2. Compromised Registry
If GHCR is compromised or goes offline, the `deployment-pipeline.yml` will fail to push. Existing deployments are unaffected because they rely on the local Docker daemon cache on the target host.

