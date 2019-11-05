FROM ubuntu:16.04

ARG HELMVER=2.14.3

RUN apt-get update \
  && apt-get install -y apt-transport-https apt-file jq nano ssh curl tar dnsutils gnupg lsb-release git  python python-pip vim bash-completion

RUN curl https://storage.googleapis.com/kubernetes-helm/helm-v$HELMVER-linux-amd64.tar.gz -o helm-v$HELMVER-linux-amd64.tar.gz \
  && tar -zxvf helm-v$HELMVER-linux-amd64.tar.gz \
  && chmod +x linux-amd64/helm && cp linux-amd64/helm /usr/local/bin/

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg -o cloudgoogle.gpg \
  && apt-key add cloudgoogle.gpg \
  && echo "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update && apt-get install -y kubectl

RUN pip install awscli

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/azure-cli.list \
  && curl -L https://packages.microsoft.com/keys/microsoft.asc -o microsoft.asc && apt-key add microsoft.asc \
  && apt-get update && apt-get install azure-cli

RUN curl -L https://github.com/Azure/acs-engine/releases/download/v0.20.9/acs-engine-v0.20.9-linux-amd64.tar.gz -o acs-engine-v0.20.9-linux-amd64.tar.gz \
  && tar -zxf acs-engine-v0.20.9-linux-amd64.tar.gz \
  && mv acs-engine-v0.20.9-linux-amd64/acs-engine /usr/local/bin/ && chmod +x /usr/local/bin/acs-engine

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/local/bin/
RUN chmod +x /usr/local/bin/eksctl

RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && chmod +x aws-iam-authenticator && mv aws-iam-authenticator /usr/local/bin
  
RUN adduser --quiet --gecos "Cloud Client,IT,0,0" --disabled-password --home /home/cc cc && chown -Rf cc:cc /home/cc

COPY bash.bashrc /etc/bash.bashrc
WORKDIR /home/cc/  

USER cc:cc
