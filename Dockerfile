FROM amazon/aws-cli
LABEL maintainer "Joshua Oster-Morris <josh@craftycoder.com>"

ARG TKN_VERSION=0.21.0

RUN yum install -y wget tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN ARCH=$(uname -m) && wget -O- https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/tkn_${TKN_VERSION}_Linux_${ARCH}.tar.gz | tar zxf - -C /usr/local/bin

RUN  /usr/local/bin/aws --version

RUN  /usr/local/bin/tkn version

RUN mkdir /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
RUN chmod +x /workdir/entrypoint.sh

ENTRYPOINT ["/workdir/entrypoint.sh"]