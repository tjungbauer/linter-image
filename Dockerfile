FROM --platform=linux/amd64 registry.access.redhat.com/ubi10/ubi-minimal:latest

# Tool versions
ARG HELM_VERSION=3.19.2
ARG KUBELINTER_VERSION=0.7.6
ARG KUBESCORE_VERSION=1.20.0

LABEL com.redhat.component="k8s-linter-container" \
      name="linter-image" \
      summary="Kubernetes manifest linting tools" \
      description="Container image with Helm, kube-linter, kube-score, and yamllint for Kubernetes manifest validation" \
      maintainer="tjungbauer"

RUN microdnf update -y \
    && microdnf install -y curl tar gzip python3-pip \
    && pip3 install --no-cache-dir yamllint \
    && curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar -xz -C /usr/local/bin --strip-components=1 linux-amd64/helm \
    && curl -fsSL -L "https://github.com/stackrox/kube-linter/releases/download/v${KUBELINTER_VERSION}/kube-linter-linux.tar.gz" | tar -xz -C /usr/local/bin kube-linter \
    && curl -fsSL -L "https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64.tar.gz" | tar -xz -C /usr/local/bin kube-score \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kube-linter /usr/local/bin/kube-score \
    && microdnf remove -y curl tar gzip \
    && microdnf clean all \
    && rm -rf /var/cache/yum

# Create non-root user
RUN echo "linter:x:1000:1000:Linter User:/home/linter:/bin/sh" >> /etc/passwd \
    && mkdir -p /home/linter \
    && chown 1000:1000 /home/linter

WORKDIR /home/linter
USER 1000

CMD ["/bin/sh"]
