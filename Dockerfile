FROM --platform=linux/amd64 registry.access.redhat.com/ubi10/ubi-minimal:latest@sha256:67aafc6c9c44374e1baf340110d4c835457d59a0444c068ba9ac6431a6d9e7ac

# Tool versions
ARG HELM_VERSION=3.19.2
ARG KUBELINTER_VERSION=0.7.1
ARG KUBESCORE_VERSION=1.19.0

LABEL com.redhat.component="k8s-linter-container" \
      name="linter-image" \
      summary="Kubernetes manifest linting tools" \
      description="Container image with Helm, kube-linter, kube-score, and yamllint for Kubernetes manifest validation" \
      maintainer="tjungbauer"

# Install dependencies
RUN microdnf update -y \
    && microdnf install -y curl tar gzip python3 python3-pip shadow-utils \
    && python3 -m pip install --no-cache-dir yamllint

# Download and install Helm
RUN curl -fsSL -o /tmp/helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -xzf /tmp/helm.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /tmp/helm.tar.gz /tmp/linux-amd64

# Download and install kube-linter
RUN curl -fsSL -o /tmp/kube-linter.tar.gz -L "https://github.com/stackrox/kube-linter/releases/download/v${KUBELINTER_VERSION}/kube-linter-linux.tar.gz" \
    && tar -xzf /tmp/kube-linter.tar.gz -C /usr/local/bin kube-linter \
    && chmod +x /usr/local/bin/kube-linter \
    && rm -f /tmp/kube-linter.tar.gz

# Download and install kube-score
RUN curl -fsSL -o /tmp/kube-score.tar.gz -L "https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64.tar.gz" \
    && tar -xzf /tmp/kube-score.tar.gz -C /usr/local/bin kube-score \
    && chmod +x /usr/local/bin/kube-score \
    && rm -f /tmp/kube-score.tar.gz

# Cleanup package cache
RUN microdnf clean all \
    && rm -rf /var/cache/yum /tmp/*

# Create non-root user
RUN useradd -m -s /bin/sh -u 1000 linter

WORKDIR /home/linter
USER 1000

CMD ["/bin/sh"]
