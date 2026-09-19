# azure-security-terraform-block2
Secure Azure infrastructure built with Terraform, OIDC federation, AKS, policy-as-code and automated security scanning.

# Azure Security Engineering Block 2

This project documents the implementation of a security-focused Azure environment using Terraform, GitHub Actions, Azure Kubernetes Service (AKS), Azure RBAC, private networking, workload identity, and Infrastructure-as-Code security scanning.

The environment was built as part of Block 2 of my cloud security engineering roadmap.

## Project Objectives

The goal of this project is to build and secure Azure infrastructure using Infrastructure as Code while applying practical cloud security controls.

Key objectives include:

- Deploy Azure infrastructure with Terraform
- Secure Terraform remote state
- Implement private connectivity for Azure Storage
- Use Azure RBAC instead of shared access keys
- Configure GitHub Actions authentication with OIDC
- Scan Terraform code with Checkov and Trivy
- Deploy an AKS cluster using Terraform
- Enable Kubernetes RBAC
- Configure AKS Workload Identity
- Implement least-privilege Azure access for Kubernetes workloads
- Apply Kubernetes NetworkPolicy controls
- Continue with admission policies, image scanning, Azure Policy-as-Code, and Defender for Cloud

## Architecture

The environment currently includes:

- Azure Resource Group
- Azure Virtual Network
- Application subnet
- AKS subnet
- Private Endpoint subnet
- Network Security Groups
- Azure Storage Account
- Storage Private Endpoint
- Private DNS Zone
- Azure Key Vault
- Azure RBAC role assignments
- Terraform remote state Storage Account
- GitHub Actions OIDC authentication
- AKS cluster
- User-assigned managed identities
- AKS Workload Identity federation
- Kubernetes Service Accounts
- Kubernetes RBAC
- Kubernetes NetworkPolicy

## Security Controls Implemented

### Terraform Remote State

Terraform state is stored remotely in a dedicated Azure Storage Account.

Security controls include:

- Azure RBAC authentication
- Shared Key authentication disabled
- Blob versioning and retention
- Storage Blob Data Contributor permissions
- Management lock protecting the state storage account

### Azure Storage Security

The application Storage Account includes:

- Public network access disabled
- Shared Key authorization disabled
- TLS 1.2 enforcement
- HTTPS-only traffic
- Blob and container soft delete
- Private Endpoint connectivity
- Private DNS integration
- Network access default action set to Deny

### Azure Key Vault

The Key Vault uses:

- Azure RBAC authorization
- Soft delete
- Least-privilege role assignments
- Key Vault Secrets Officer for administrative testing
- Key Vault Secrets User for the AKS workload identity

### GitHub Actions OIDC

GitHub Actions authenticates to Azure using OpenID Connect instead of a client secret.

The pipeline performs:

- Terraform formatting validation
- Terraform initialization
- Terraform validation
- Terraform planning
- Checkov Infrastructure-as-Code scanning
- Trivy Terraform security scanning

### Infrastructure-as-Code Security Scanning

Checkov and Trivy are used to detect Terraform security misconfigurations.

Findings were reviewed individually.

Security issues that could be remediated were fixed, while intentional lab exceptions were documented directly in the Terraform configuration.

### Azure Kubernetes Service

AKS is deployed using Terraform with:

- Azure CNI Overlay networking
- Cilium networking and NetworkPolicy enforcement
- Kubernetes RBAC enabled
- OIDC issuer enabled
- AKS Workload Identity enabled
- User-assigned managed identity
- Dedicated AKS subnet
- Network Security Group protection

### AKS Workload Identity

AKS Workload Identity was configured to allow Kubernetes workloads to authenticate to Azure without storing client secrets.

The implementation includes:

- Kubernetes Service Account
- Azure user-assigned managed identity
- Federated identity credential
- OIDC federation
- Key Vault Secrets User role assignment

Testing confirmed that the workload could authenticate to Azure and read Key Vault secret metadata while write operations were denied.

### Kubernetes RBAC

Namespace-scoped RBAC was implemented using:

- Kubernetes Role
- RoleBinding
- Service Account

The workload was granted read-only permissions for selected resources inside the `block2-app` namespace.

Testing confirmed:

- Pod read access was allowed
- Service listing was allowed
- Pod deletion was denied
- Access outside the namespace was denied

### Kubernetes NetworkPolicy

Cilium NetworkPolicy enforcement was enabled on the AKS cluster.

Network policies were created to restrict inbound communication between Kubernetes workloads.

The policy allows approved pods to communicate with the protected workload while unauthorized pods are blocked.

## Repository Structure

```text
azure-security-terraform-block2/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── terraform/
│   ├── 00-bootstrap-state/
│   └── 01-foundation/
│       ├── aks.tf
│       ├── keyvault.tf
│       ├── main.tf
│       ├── network.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── storage.tf
│       ├── variables.tf
│       ├── versions.tf
│       ├── workload-identity.tf
│       └── kubernetes/
│           ├── test-workload.yaml
│           ├── workload-rbac.yaml
│           ├── workload-identity-test.yaml
│           └── network-policy.yaml
├── screenshots/
├── .gitignore
└── README.md