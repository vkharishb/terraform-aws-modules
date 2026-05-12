# Terraform AWS Modules

Reusable, production-ready Terraform modules for provisioning AWS infrastructure. This repository provides modular, environment-agnostic configurations that can be consumed directly via Git source or composed together to build complete cloud environments.

---

## 📦 Modules

| Module | Description |
|---|---|
| [`vpc`](#vpc) | Multi-AZ VPC with public/private subnets, NAT gateway, and EKS-compatible tagging |
| [`eks`](#eks) | EKS cluster with a managed node group |
| [`iam-eks`](#iam-eks) | IAM roles and instance profiles required for EKS clusters and node groups |
| [`ec2`](#ec2) | EC2 instance with optional IAM role creation |
| [`s3`](#s3) | S3 bucket with versioning and environment tagging |

---

## 📁 Repository Structure

```text
terraform-aws-modules/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── locals.tf
│   │   └── versions.tf
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── iam-eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   └── s3/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── examples/
│   ├── vpc-basic/
│   ├── eks-basic/
│   ├── iam-eks-basic/
│   ├── ec2-basic/
│   └── s3-basic/
│
└── README.md
```

---

## ✅ Requirements

| Tool | Version |
|---|---|
| Terraform | `>= 1.3.0` |
| AWS Provider | `~> 5.0` |

---

## 🔧 Usage

All modules can be sourced directly from GitHub using the `git::` source syntax, pinned to the `main` branch.

---

### VPC

Creates a VPC with public and private subnets spread across multiple Availability Zones, with optional NAT gateway and VPC flow log support.

```hcl
module "vpc" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/vpc?ref=main"

  name       = "demo-vpc"
  cidr_block = "10.0.0.0/16"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_flow_logs   = false

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

**Variables**

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | — | Name prefix for all resources |
| `cidr_block` | `string` | — | VPC CIDR block (must be a valid CIDR) |
| `az_count` | `number` | `2` | Number of Availability Zones to use (2 or 3) |
| `public_subnets` | `list(string)` | `[]` | Public subnet CIDR blocks. Leave empty to auto-generate from `cidr_block` |
| `private_subnets` | `list(string)` | `[]` | Private subnet CIDR blocks. Leave empty to auto-generate from `cidr_block` |
| `enable_nat_gateway` | `bool` | `true` | Whether to create a NAT gateway |
| `single_nat_gateway` | `bool` | `true` | Use a single NAT gateway instead of one per AZ |
| `enable_flow_logs` | `bool` | `false` | Whether to enable VPC flow logs |
| `tags` | `map(string)` | `{}` | Tags to apply to all resources |

**Outputs**

| Name | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `public_subnets` | List of public subnet IDs |
| `private_subnets` | List of private subnet IDs |

---

### EKS

Creates an EKS cluster and a managed node group. Requires subnet IDs and IAM role ARNs — use the `iam-eks` module to create those.

```hcl
module "eks" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/eks?ref=main"

  cluster_name    = "demo-eks"
  cluster_version = "1.29"

  subnet_ids = module.vpc.private_subnets

  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}
```

**Variables**

| Name | Type | Default | Description |
|---|---|---|---|
| `cluster_name` | `string` | — | Name of the EKS cluster |
| `cluster_version` | `string` | `"1.29"` | Kubernetes version |
| `subnet_ids` | `list(string)` | — | Subnet IDs for the cluster and node group |
| `cluster_role_arn` | `string` | — | IAM role ARN for the EKS cluster |
| `node_role_arn` | `string` | — | IAM role ARN for the node group |

**Outputs**

| Name | Description |
|---|---|
| `cluster_name` | Name of the EKS cluster |
| `cluster_endpoint` | API server endpoint of the EKS cluster |

---

### IAM EKS

Creates the IAM roles and instance profile required for EKS — the cluster control-plane role, the node group role, and the EC2 instance profile.

```hcl
module "iam" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/iam-eks?ref=main"

  cluster_name = "demo-eks"

  tags = {
    Environment = "dev"
    Project     = "eks"
  }
}
```

**Variables**

| Name | Type | Default | Description |
|---|---|---|---|
| `cluster_name` | `string` | — | EKS cluster name (used to name IAM resources) |
| `tags` | `map(string)` | `{}` | Tags to apply to all resources |

**Outputs**

| Name | Description |
|---|---|
| `cluster_role_arn` | ARN of the EKS cluster IAM role |
| `node_role_arn` | ARN of the node group IAM role |
| `node_instance_profile` | Name of the EC2 instance profile for nodes |

---

### EC2

Creates an EC2 instance in a given subnet with optional IAM role attachment.

```hcl
module "ec2" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/ec2?ref=main"

  name          = "my-instance"
  ami_id        = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  create_iam_role = false

  tags = {
    Environment = "dev"
  }
}
```

**Variables**

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | — | Name tag for the instance |
| `ami_id` | `string` | — | AMI ID to use for the instance |
| `instance_type` | `string` | `"t3.micro"` | EC2 instance type |
| `subnet_id` | `string` | — | Subnet ID to launch the instance into |
| `vpc_security_group_ids` | `list(string)` | — | Security group IDs to attach |
| `create_iam_role` | `bool` | `false` | Whether to create and attach an IAM role to the instance |
| `iam_role_name` | `string` | `null` | IAM role name to use (when `create_iam_role = false`) |
| `user_data` | `string` | `null` | User data script to run on launch |
| `tags` | `map(string)` | — | Tags to apply to the instance |

**Outputs**

| Name | Description |
|---|---|
| `instance_id` | ID of the EC2 instance |
| `private_ip` | Private IP address of the instance |

---

### S3

Creates an S3 bucket with optional versioning enabled.

```hcl
module "s3" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/s3?ref=main"

  bucket_name = "my-unique-bucket-name-12345"
  environment = "dev"
  versioning  = true

  tags = {
    Project = "my-project"
  }
}
```

**Variables**

| Name | Type | Default | Description |
|---|---|---|---|
| `bucket_name` | `string` | — | Globally unique S3 bucket name |
| `environment` | `string` | `"dev"` | Environment tag value |
| `versioning` | `bool` | `true` | Whether to enable S3 versioning |
| `tags` | `map(string)` | `{}` | Additional tags to apply |

**Outputs**

| Name | Description |
|---|---|
| `bucket_name` | Name of the created S3 bucket |
| `bucket_arn` | ARN of the created S3 bucket |

---

## 🗂 Examples

Complete working examples are available in the [`examples/`](./examples) directory.

| Example | Description |
|---|---|
| [`vpc-basic`](./examples/vpc-basic) | Standalone VPC with public/private subnets and NAT gateway |
| [`eks-basic`](./examples/eks-basic) | Full EKS setup using the `vpc`, `iam-eks`, and `eks` modules together |
| [`iam-eks-basic`](./examples/iam-eks-basic) | Standalone IAM role creation for EKS |
| [`ec2-basic`](./examples/ec2-basic) | EC2 instance launched in the default VPC |
| [`s3-basic`](./examples/s3-basic) | S3 bucket with versioning enabled |

### Running an example

```bash
cd examples/vpc-basic
terraform init
terraform plan
terraform apply
```

---

## 🏗 Complete EKS Stack Example

The following shows how to compose the `vpc`, `iam-eks`, and `eks` modules together to stand up a fully functional EKS cluster:

```hcl
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/vpc?ref=main"

  name       = "demo-vpc"
  cidr_block = "10.0.0.0/16"

  tags = { Environment = "dev" }
}

module "iam" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/iam-eks?ref=main"

  cluster_name = "demo-eks"
  tags         = { Environment = "dev" }
}

module "eks" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/eks?ref=main"

  cluster_name     = "demo-eks"
  cluster_version  = "1.29"
  subnet_ids       = module.vpc.private_subnets
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}
```

---

## 🤝 Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-change`
3. Commit your changes: `git commit -m "feat: add my change"`
4. Push and open a Pull Request.

Please keep module interfaces backward-compatible and include or update examples for any new module.

---

## 📄 License

This project is open-source. See [LICENSE](./LICENSE) for details.
