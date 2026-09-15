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

### Terraform Documentation Structure

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


## Secure Azure Networking

### Objective

Terraform was used to create the network foundation for the Block 2 Azure environment.

The network was designed to separate application and container workloads while leaving room for private connectivity later in the project.

### Network Architecture

The following network resources were deployed:

- Virtual Network: `vnet-block2-security-lab`
- Address Space: `10.20.0.0/16`
- Application Subnet: `snet-app` - `10.20.1.0/24`
- AKS Subnet: `snet-aks` - `10.20.2.0/24`
- Network Security Group: `nsg-block2-app`

A separate private endpoint subnet will be introduced later when private connectivity is configured for Azure Storage.

### Network Security

The application subnet was associated with the `nsg-block2-app` Network Security Group.

A custom inbound rule was configured to allow HTTPS traffic on TCP port 443.

Other unsolicited inbound traffic remains restricted by Azure's default Network Security Group rules.

### Terraform Validation

The networking configuration was formatted and validated before deployment.

Terraform produced the following deployment plan:

`Plan: 5 to add, 0 to change, 0 to destroy.`

The plan included:

- One Virtual Network
- Two Subnets
- One Network Security Group
- One NSG-to-subnet association

The resources were successfully deployed and verified in the Azure Portal.

### Infrastructure-as-Code

The networking configuration is managed through Terraform rather than manual Azure Portal deployment.

This allows the network architecture to be reproduced consistently and helps detect future configuration drift.


## Azure Key Vault with RBAC

### Objective

Azure Key Vault was deployed using Terraform to provide secure storage for secrets while using Azure Role-Based Access Control for authorization.

The Key Vault uses Azure RBAC rather than the legacy Key Vault access policy model.

### Terraform Configuration

The Key Vault was configured with:

- Standard pricing tier
- Azure RBAC authorization enabled
- Soft delete enabled
- Terraform-managed resource tags
- A globally unique Key Vault name generated using the Terraform Random provider

The configuration included:

`enable_rbac_authorization = true`

### Azure RBAC

The existing authenticated Azure identity was assigned the built-in:

`Key Vault Secrets Officer`

role at the Key Vault resource scope.

The role assignment was created through Terraform and limited to the Key Vault rather than granting broader tenant-level permissions.

No Microsoft Entra administrative roles were required for this implementation.

### Access Validation

RBAC access was validated by creating a test secret inside the Key Vault.

The successful secret creation confirmed that the assigned Azure RBAC role provided the expected Key Vault data-plane permissions.

No production passwords, API keys, or sensitive credentials were used during testing.

### Identity Constraint

The Azure subscription is connected to an institution-managed Microsoft Entra tenant where student accounts do not have Entra administrative privileges.

The Documentation therefore avoids unnecessary tenant-level identity configuration and uses Azure resource-level RBAC and managed identities where possible.


## Private Azure Storage

### Objective

Azure Storage was deployed using Terraform with public network access disabled and private connectivity provided through Azure Private Link.

### Storage Security

The Storage Account was configured with:

- Standard performance tier
- Locally redundant storage
- HTTPS-only traffic
- Minimum TLS version 1.2
- Public blob access disabled
- Public network access disabled

### Private Connectivity

A dedicated subnet was created for private endpoints:

`snet-private-endpoints - 10.20.3.0/24`

A private endpoint was created for the Storage Account Blob service.

The private endpoint received an IP address from the private endpoint subnet, allowing Storage traffic to remain within the Azure virtual network.

### Private DNS

The following Private DNS zone was created:

`privatelink.blob.core.windows.net`

The zone was linked to the Block 2 virtual network so Storage Blob hostnames can resolve to the private endpoint rather than the public endpoint.

### Validation

The following controls were validated in the Azure Portal:

- Public network access was disabled.
- The Storage private endpoint connection was approved.
- The private endpoint received a private IP address.
- The Private DNS zone was linked to the virtual network.