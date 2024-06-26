FROM registry.access.redhat.com/ubi9/ubi:latest

ARG helm_version=3.14.4
ARG kubelinter_version=0.6.8
ARG kubescore_version=1.18.0

LABEL maintainer="Thomas Jungbauer"

LABEL com.redhat.component="ubi9-container" \
      name="ubi9" \
      version="9.1.0"

ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash"]

RUN rm -rf /var/log/*
#rhbz 1609043
RUN mkdir -p /var/log/rhsm

RUN curl -s -O https://get.helm.sh/helm-v{$helm_version}-linux-amd64.tar.gz \
  && tar -xf helm-v${helm_version}-linux-amd64.tar.gz linux-amd64/helm  \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm 

RUN curl -s -O -L https://github.com/stackrox/kube-linter/releases/download/v${kubelinter_version}/kube-linter-linux.tar.gz \
  && tar -xf kube-linter-linux.tar.gz \
  && mv kube-linter /usr/local/bin/kube-linter \
  && chmod +x /usr/local/bin/kube-linter

RUN curl -s -O -L https://github.com/zegl/kube-score/releases/download/v${kubescore_version}/kube-score_${kubescore_version}_linux_amd64.tar.gz \
  && tar -xf kube-score_${kubescore_version}_linux_amd64.tar.gz \
  && mv kube-score /usr/local/bin/kube-score \
  && chmod +x /usr/local/bin/kube-score

RUN dnf install -y python3-pip && pip install yamllint

RUN rm -Rf linux-amd64/ kube-linter-linux.tar.gz helm-v${helm_version}-linux-amd64.tar.gz kube-score_${kubescore_version}_linux_amd64.tar.gz LICENSE

