# azure-security-terraform-block2
Secure Azure infrastructure built with Terraform, OIDC federation, AKS, policy-as-code and automated security scanning.

# Azure Security Engineering with Terraform

## Documentation Overview

This project documents the implementation of Caleb's Block 2 cloud security roadmap using Microsoft Azure, Terraform, GitHub Actions, Kubernetes and policy-as-code.

The objective is to build and secure Azure infrastructure using declarative infrastructure-as-code while learning desired state, reconciliation and configuration drift.

## Block 2 Objectives

- Provision Azure infrastructure using Terraform.
- Configure secure networking and Network Security Groups.
- Deploy Azure Key Vault using Azure RBAC.
- Deploy Azure Storage with private connectivity.
- Secure Terraform remote state.
- Deploy Terraform through GitHub Actions using OIDC federation without stored Azure secrets.
- Perform infrastructure security scanning.
- Provision and secure an AKS cluster.
- Implement Kubernetes RBAC and network policies.
- Configure Azure Workload Identity.
- Implement Azure Policy and Kubernetes admission policies.
- Establish a Defender for Cloud security baseline.

## Environment

- Azure subscription: Azure for Students
- Primary Azure region: Poland Central
- Infrastructure-as-Code: Terraform
- Source control and CI/CD: GitHub
- Authentication: OpenID Connect and Azure Managed Identity

## Cost Management

Azure cost monitoring was configured before infrastructure deployment. Expensive resources such as AKS will only be deployed when required for testing and will be destroyed after validation to conserve Azure student credits.

## Documentation Status

Block 2 implementation in progress.


## Terraform Foundation

### Objective

The first Terraform lab was used to validate the local Infrastructure-as-Code environment before deploying the main Block 2 infrastructure.

The lab focused on understanding Terraform's declarative workflow, provider initialization, resource deployment, state management, drift detection, and reconciliation.

### Terraform Project Structure

The Terraform configuration was separated into the following files:

- `versions.tf` - Defines the required Terraform and AzureRM provider versions.
- `provider.tf` - Configures the Azure Resource Manager provider.
- `variables.tf` - Defines reusable configuration values such as the Azure region and resource group name.
- `main.tf` - Contains the Azure resource definitions.
- `outputs.tf` - Displays useful information after deployment.

The primary deployment region for this project is **Poland Central**.

### Initial Terraform Workflow

The following Terraform workflow was used:

`terraform fmt` → `terraform init` → `terraform validate` → `terraform plan` → `terraform apply`

- `terraform fmt` formatted the Terraform configuration.
- `terraform init` initialized the working directory and downloaded the AzureRM provider.
- `terraform validate` verified that the configuration was syntactically valid.
- `terraform plan` previewed the infrastructure changes before deployment.
- `terraform apply` created the declared infrastructure in Azure.

The initial deployment created the following Azure resource:

- Resource Group: `rg-block2-security-lab`
- Region: Poland Central
- Managed by: Terraform

### Terraform State

Terraform created a local state file to track the relationship between the Terraform configuration and the deployed Azure resources.

The Terraform state file was excluded from Git using `.gitignore` because state files may contain sensitive infrastructure information.

Remote state storage will be implemented later in the project as part of the Block 2 security requirements.

### Drift Detection and Reconciliation

To demonstrate configuration drift, the `environment` tag on the resource group was manually changed in the Azure Portal from:

`lab`

to:

`manual-change`

The Terraform configuration still declared the expected value as:

`lab`

Running `terraform plan` detected that the deployed Azure resource no longer matched the declared Terraform configuration.

Terraform reported:

`Plan: 0 to add, 1 to change, 0 to destroy.`

Running `terraform apply` reconciled the resource and restored the environment tag to the expected value.

This demonstrated the core Infrastructure-as-Code model used throughout Block 2:

**Desired State → Drift Detection → Reconciliation**

### Security Considerations

- Terraform state files are excluded from source control.
- No Azure credentials or secrets are stored in the repository.
- Azure CLI authentication is currently used for local Terraform deployments.
- GitHub OIDC federation will be implemented later to remove the need for stored deployment credentials.
- Cost monitoring was configured before deploying chargeable Azure infrastructure.
