# azure-security-terraform-block2
Secure Azure infrastructure built with Terraform, OIDC federation, AKS, policy-as-code and automated security scanning.

# Azure Security Engineering Block 2

## Documentation Overview

This repository contains the Terraform, Kubernetes, GitHub Actions, and Azure Policy configurations I used to build and secure my Block 2 Azure environment.

I used Terraform as the main Infrastructure-as-Code tool and kept the infrastructure configuration in source control so that the environment can be reviewed, validated, and recreated when required.

The environment includes Azure networking, Storage, Key Vault, AKS, Workload Identity, Kubernetes RBAC, NetworkPolicy, GitHub Actions OIDC, Infrastructure-as-Code scanning, Azure Policy, Log Analytics, and Defender for Cloud validation.

Detailed implementation steps and screenshots are documented in:

[BLOCK2-IMPLEMENTATION-GUIDE.md](./BLOCK2-IMPLEMENTATION-GUIDE.md)

---

## Repository Structure

```text
azure-security-terraform-block2/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── screenshots/
│
├── terraform/
│   ├── 00-bootstrap-state/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   └── versions.tf
│   │
│   └── 01-foundation/
│       ├── aks.tf
│       ├── keyvault.tf
│       ├── main.tf
│       ├── network.tf
│       ├── outputs.tf
│       ├── policy.tf
│       ├── policy-dine.tf
│       ├── provider.tf
│       ├── storage.tf
│       ├── variables.tf
│       ├── versions.tf
│       ├── workload-identity.tf
│       │
│       └── kubernetes/
│           ├── test-workload.yaml
│           ├── workload-rbac.yaml
│           ├── workload-identity-test.yaml
│           └── network-policy.yaml
│
├── .gitignore
├── BLOCK2-IMPLEMENTATION-GUIDE.md
└── README.md
