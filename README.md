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
