FROM alpine:3.16
LABEL maintainer="Sergey Prokhorov <lisforlinux@gmail.com>"

ARG KUBE_VERSION="v1.25.0"
ARG SOPS_VERSION="3.7.3"
ARG HELM_VERSION="v3.9.4"
ARG HELM_DIFF_VERSION="v3.5.0"
ARG YQ_VERSION="4.27.3"
ARG CHART_TESTING_VERSION="3.7.0"

ENV HELM_PLUGIN_DIR /root/.helm/plugins/helm-diff

RUN apk --no-cache add \
        ca-certificates \
        jq \
        curl \
        python3 \
        python3-dev \
        git \
        bash \
        coreutils \
    && rm -rf /var/cache/apk/*

RUN curl -s -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -o /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops && \
    curl -s https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    curl -s https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    mkdir -p /tmp/ct && \
    curl -S -L \
    "https://github.com/helm/chart-testing/releases/download/v${CHART_TESTING_VERSION}/chart-testing_${CHART_TESTING_VERSION}_linux_amd64.tar.gz" | \
    tar -xz -C /tmp/ct && \
    install --mode 0555 /tmp/ct/ct /usr/bin/ct && \
    rm -rf /tmp/ct 
