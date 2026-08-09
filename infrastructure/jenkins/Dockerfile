FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        git \
        jq \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH="$(dpkg --print-architecture)" \
    && case "${ARCH}" in \
         amd64) AWS_ARCH="x86_64" ;; \
         arm64) AWS_ARCH="aarch64" ;; \
         *) echo "Unsupported architecture: ${ARCH}" && exit 1 ;; \
       esac \
    && curl -fsSL \
       "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
       -o /tmp/awscliv2.zip \
    && cd /tmp \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf /tmp/aws /tmp/awscliv2.zip

USER jenkins

RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    pipeline-stage-view
