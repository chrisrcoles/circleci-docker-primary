# CircleCI primary docker image to run within
FROM circleci/python:3.6

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Truss CircleCI Primary Docker Image" \
      org.label-schema.description="Truss custom-built docker image for CircleCI 2.0 jobs. Includes all tools needed to be a \"primary container\" as well as tools we test and deploy with." \
      org.label-schema.url="https://truss.works/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/trussworks/circleci-docker-primary" \
      org.label-schema.vendor="TrussWorks, Inc." \
      org.label-schema.version=$VCS_REF \
      org.label-schema.schema-version="1.0"

# setup apt
RUN set -ex && cd ~ \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install apt-transport-https lsb-release

# install Node.js
RUN set -ex && cd ~ \
  && curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - \
  && echo "deb https://deb.nodesource.com/node_8.x $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install nodejs

# install Yarn
RUN set -ex && cd ~ \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-get -qq update \
  && sudo apt-get -qq -y install yarn

# install Go
RUN set -ex && cd ~ \
  && curl -LO https://dl.google.com/go/go1.10.linux-amd64.tar.gz \
  && sudo tar -C /usr/local -xzf go1.10.linux-amd64.tar.gz \
  && sudo ln -s /usr/local/go/bin/* /usr/local/bin \
  && rm go1.10.linux-amd64.tar.gz

# install latest aws cli
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     awscli

# install latest pre-commit
RUN set -ex && cd ~ \
  && sudo pip install --no-cache-dir --disable-pip-version-check \
     pre-commit==1.8.1

# install latest shellcheck
RUN set -ex && cd ~ \
  && curl -LO https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz \
  && tar xvfa shellcheck-latest.linux.x86_64.tar.xz \
  && sudo mv shellcheck-latest/shellcheck /usr/local/bin \
  && rm -rf shellcheck-latest shellcheck-latest.linux.x86_64.tar.xz

# install terraform
RUN set -ex && cd ~ \
  && curl -LO https://releases.hashicorp.com/terraform/0.11.4/terraform_0.11.4_linux_amd64.zip \
  && sudo unzip -d /usr/local/bin terraform_0.11.4_linux_amd64.zip \
  && rm -f terraform_0.11.4_linux_amd64.zip

CMD ["/bin/sh"]
