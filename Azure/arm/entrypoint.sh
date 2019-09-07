#!/bin/bash

set -e
export AZURE_HTTP_USER_AGENT="GITHUBACTIONS_${GITHUB_ACTION_NAME}_${GITHUB_REPOSITORY}"

URI_REGEX="^(http://|https://)\\w+"
GUID=$(uuidgen | cut -d '-' -f 1)

if [[ -z "$SCOPE" ]]
then
  SCOPE = "RESOURCE_GROUP"
fi

if [[ ${SCOPE,,} == "RESOURCE_GROUP" ]] && [[ -z "$AZURE_RESOURCE_GROUP" ]]
then
  echo "AZURE_RESOURCE_GROUP is not set." >&2
  exit 1
fi

if [[ -z "$AZURE_TEMPLATE_LOCATION" ]]
then
    echo "AZURE_TEMPLATE_FILE is not set." >&2
    exit 1
fi


# Download parameters file if it is a remote URL

if [[ -z "$AZURE_TEMPLATE_PARAM_LOCATION" ]]
then
  echo "No parameter files set"
else
  if [[ $AZURE_TEMPLATE_PARAM_LOCATION =~ $URI_REGEX ]]
  then
    PARAMETERS=$(curl "$AZURE_TEMPLATE_PARAM_LOCATION")
    echo "Downloaded parameters from ${AZURE_TEMPLATE_PARAM_LOCATION}"
  else
    PARAMETERS_FILE = "${GITHUB_WORKSPACE}/${AZURE_TEMPLATE_PARAM_LOCATION}"
    if [[ ! -e "$PARAMETERS_FILE" ]]
    then
      echo "Parameters file ${PARAMETERS_FILE} does not exits." >&2
      exit 1
    fi
    PARAMETERS = "@${PARAMETERS_FILE}"
  fi
fi

# Generate deployment name if not specified

if [[ -z "$DEPLOYMENT_NAME" ]]
then
  DEPLOYMENT_NAME="Github-Action-ARM-${GUID}"
  echo "Generated Deployment Name ${DEPLOYMENT_NAME}"
fi

# Deploy ARM template

if [[ ${SCOPE,,} == "RESOURCE_GROUP" ]]
then
  if [[ $AZURE_TEMPLATE_LOCATION =~ $URI_REGEX ]]
  then
    if [[ -z "$PARAMETERS" ]]
    then
      az group deployment create -g "$AZURE_RESOURCE_GROUP" --name "$DEPLOYMENT_NAME" --template-uri "$AZURE_TEMPLATE_LOCATION"
    else
      az group deployment create -g "$AZURE_RESOURCE_GROUP" --name "$DEPLOYMENT_NAME" --template-uri "$AZURE_TEMPLATE_LOCATION" --parameters "$PARAMETERS"
    fi
  else
    TEMPLATE_FILE = "${GITHUB_WORKSPACE}/${AZURE_TEMPLATE_LOCATION}"
    if [[ ! -e "$TEMPLATE_FILE" ]]
    then
      echo "Template file ${TEMPLATE_FILE} does not exists." >&2
      exit 1
    fi
    if [[ -z "$PARAMETERS" ]]
    then
      az group deployment create -g "$AZURE_RESOURCE_GROUP" --name "$DEPLOYMENT_NAME" --template-file "$AZURE_TEMPLATE_LOCATION"
    else
      az group deployment create -g "$AZURE_RESOURCE_GROUP" --name "$DEPLOYMENT_NAME" --template-file "$AZURE_TEMPLATE_LOCATION" --parameters "$PARAMETERS"
    fi
  fi
fi

if [[ ${SCOPE,,} == "SUBSCRIPTION" ]]
then
  if [[ $AZURE_TEMPLATE_LOCATION =~ $URI_REGEX ]]
  then
    if [[ -z "$PARAMETERS" ]]
    then
      az deployment create --location "$DEPLOYMENT_LOCATION" --name "$DEPLOYMENT_NAME" --template-uri "$AZURE_TEMPLATE_LOCATION"
    else
      az deployment create --location "$DEPLOYMENT_LOCATION" --name "$DEPLOYMENT_NAME" --template-uri "$AZURE_TEMPLATE_LOCATION" --parameters "$PARAMETERS"
    fi
  else
    TEMPLATE_FILE = "${GITHUB_WORKSPACE}/${AZURE_TEMPLATE_LOCATION}"
    if [[ ! -e "$TEMPLATE_FILE" ]]
    then
      echo "Template file ${TEMPLATE_FILE} does not exists." >&2
      exit 1
    fi
    if [[ -z "$PARAMETERS" ]]
    then
      az deployment create --location "$DEPLOYMENT_LOCATION" --name "$DEPLOYMENT_NAME" --template-file "$AZURE_TEMPLATE_LOCATION"
    else
      az deployment create --location "$DEPLOYMENT_LOCATION" --name "$DEPLOYMENT_NAME" --template-file "$AZURE_TEMPLATE_LOCATION" --parameters "$PARAMETERS"
    fi
  fi
fi