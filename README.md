# Terraform AWS Modules

Reusable, production-ready Terraform modules for provisioning AWS infrastructure.

This repository provides modular, scalable, and environment-agnostic Terraform configurations for building cloud infrastructure such as VPC, EKS, and supporting services.

---

## 🚀 Features

- Modular architecture (VPC, EKS-ready networking)
- Multi-AZ support
- Public & Private subnet design
- NAT Gateway support
- EKS-compatible subnet tagging
- Reusable across environments (dev/stage/prod)

---

## 📁 Repository Structure
```text
terraform-aws-modules/
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── locals.tf
│
├── examples/
│   └── vpc-basic/
│       ├── main.tf
│       ├── providers.tf
│       └── terraform.tf
│
└── README.md
