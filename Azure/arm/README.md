# GitHub Action for deploying Azure ARM Template

This action can be used to deploy ARM Template in Azure subscription over scope of subscription or Resource group

To log into a Azure, we recommend using the [Azure Login](https://github.com/Azure/github-actions/tree/master/login) Action.

## Usages

```yaml
- name: Azure - Deploy ARM Template - Subscription Level without parameters
    uses: wilfriedwoivre/github-actions/Azure/arm@master
    env:
    SCOPE: SUBSCRIPTION
    DEPLOYMENT_LOCATION: West Europe
    AZURE_TEMPLATE_LOCATION: arm-deployment-sub.json

- name: Azure - Deploy ARM Template - Subscription Level with parameters
    uses: wilfriedwoivre/github-actions/Azure/arm@master
    env:
    SCOPE: SUBSCRIPTION
    DEPLOYMENT_LOCATION: West Europe
    AZURE_TEMPLATE_LOCATION: arm-deployment-sub.json
    AZURE_TEMPLATE_PARAM_LOCATION: arm-deployment-sub.parameters.json

- name: Azure - Deploy ARM Template - Resource Group Level without parameters
    uses: wilfriedwoivre/github-actions/Azure/arm@master
    env:
    AZURE_RESOURCE_GROUP: test-github-action-rg
    AZURE_TEMPLATE_LOCATION: arm-deployment-rg.json

- name: Azure - Deploy ARM Template - Resource Group Level with parameters
    uses: wilfriedwoivre/github-actions/Azure/arm@master
    env:
    AZURE_RESOURCE_GROUP: test-github-action-rg
    AZURE_TEMPLATE_LOCATION: arm-deployment-rg.json
    AZURE_TEMPLATE_PARAM_LOCATION: arm-deployment-rg.parameters.json  needs = ["Azure Login"]
}

```

### Environment variables

- `SCOPE` – **Optional**. Default value is RESOURCE_GROUP.

If `SCOPE` is SUBSCRIPTION

- `DEPLOYMENT_LOCATION` - **Mandatory** if `scope` is *SUBSCRIPTION*
- `AZURE_TEMPLATE_LOCATION` - **Mandatory** - Can be a URL or relative path in your github repository
- `AZURE_TEMPLATE_PARAM_LOCATION` - **Optional** - Can be a URL or relative path in your github repository

If `SCOPE` is RESOURCE_GROUP

- `AZURE_RESOURCE_GROUP` - **Mandatory** if `scope` is *RESOURCE_GROUP*
- `AZURE_TEMPLATE_LOCATION` - **Mandatory** - Can be a URL or relative path in your github repository
- `AZURE_TEMPLATE_PARAM_LOCATION` - **Optional** - Can be a URL or relative path in your github repository
