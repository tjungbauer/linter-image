# Kubernetes Linter Container Image

[![Build](https://github.com/tjungbauer/linter-image/actions/workflows/ci.yml/badge.svg)](https://github.com/tjungbauer/linter-image/actions/workflows/ci.yml)

A minimal container image with Kubernetes manifest linting and validation tools.

## Pull

```bash
# Latest version
podman pull quay.io/tjungbau/linter-image:latest

# By image version
podman pull quay.io/tjungbau/linter-image:1.0.0

# By Helm version
podman pull quay.io/tjungbau/linter-image:helm-v3.16.3
```

## Included Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Helm | 3.16.3 | Kubernetes package manager |
| kube-linter | 0.7.1 | Static analysis for K8s manifests |
| kube-score | 1.19.0 | K8s object analysis with recommendations |
| yamllint | latest | YAML file linting |

## Usage

```bash
# Lint Helm chart
podman run --rm -v $(pwd):/home/linter:Z \
  quay.io/tjungbau/linter-image:latest \
  helm lint ./my-chart

# Run kube-linter on manifests
podman run --rm -v $(pwd):/home/linter:Z \
  quay.io/tjungbau/linter-image:latest \
  kube-linter lint ./manifests/

# Run kube-score on deployment
podman run --rm -v $(pwd):/home/linter:Z \
  quay.io/tjungbau/linter-image:latest \
  kube-score score deployment.yaml

# Lint YAML files
podman run --rm -v $(pwd):/home/linter:Z \
  quay.io/tjungbau/linter-image:latest \
  yamllint -d relaxed .

# Template and lint Helm chart
podman run --rm -v $(pwd):/home/linter:Z \
  quay.io/tjungbau/linter-image:latest \
  sh -c "helm template ./my-chart | kube-linter lint -"
```

## Build Locally

```bash
# Build with default versions
podman build -t linter-image .

# Build with specific versions
podman build \
  --build-arg HELM_VERSION=3.16.3 \
  --build-arg KUBELINTER_VERSION=0.7.1 \
  --build-arg KUBESCORE_VERSION=1.19.0 \
  -t linter-image .
```

## Image Details

| Property | Value |
|----------|-------|
| Base Image | UBI 9 Minimal |
| Platform | linux/amd64 |
| User | linter (UID 1000, non-root) |
| Workdir | `/home/linter` |

