
FROM microsoft/azure-cli:2.0.47

LABEL version="1.0.0"

LABEL maintainer="Wilfried Woivré"
LABEL com.github.actions.name="Déploy ARM Template"
LABEL com.github.actions.description="GitHub Action to deploy ARM template to Azure"
LABEL com.github.actions.icon="triange"
LABEL com.github.actions.color="blue"

ENV GITHUB_ACTION_NAME="Azure - Deploy ARM Template"

RUN apk update \
  && apk add --no-cache util-linux

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]