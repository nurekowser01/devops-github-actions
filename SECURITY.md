# CI/CD Security

## Least Privilege Tokens
The `GITHUB_TOKEN` is heavily restricted using the `permissions` block:
```yaml
permissions:
  contents: read
  packages: write
  security-events: write
```

## Secret Management
Production SSH keys and environment variables are strictly held in GitHub Repository Secrets. They are never echoed to the pipeline logs.

## Dependency Caching Integrity
Node.js dependencies are cached, but `npm ci` is enforced over `npm install` to guarantee the `package-lock.json` is strictly adhered to, preventing unverified sub-dependency updates.
