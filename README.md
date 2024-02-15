# Infrastructure as Code (IaC)

## Overview

Infrastructure setup with Terraform on Google Cloud

## Prerequisites

Ensure the following prerequistes are installed and configured:

- Terraform
- Google Cloud provider account
- Google Cloud SDK

## Required Google Cloud APIs 

Ensure the following APIs are enabled in the GCP project:

- Google Compute Engine API (`compute.googleapis.com`)

 ## Configuration with tfvars

To configure infrastructure for different environments (eg dev, stage, prod):

- Create a env.tfvars file (eg, dev.tfvars, prod.tfvars, etc)
- Sample env.tfvars file:
```hcl
    environment              = "dev"
    project_id               = "gcp project id"
    region                   = "gcp region"
    webapp_subnet_name       = "subnet"
    webapp_subnet_cidr_block = "xxx.xxx.xxx.x/xx"
    db_subnet_name           = "db"
    db_subnet_cidr_block     = "xxx.xxx.xxx.x/xx"
``` 

## Usage

   **Initialize workspace**:

   ```sh
   terraform init
   ```

   **Format the files**:

   ```sh
   terraform fmt
   ```

   **Validate the configuration**:

   ```sh
   terraform validate
   ```

   **Create a plan**:

   ```sh
   terraform plan -var-file="env.tfvars"
   ```

   **Apply the configuration**:

   ```sh
   terraform apply -var-file="env.tfvars"
   ```

   **Destroy the infrastructure**:

   ```sh
   terraform destroy -var-file="env.tfvars"
   ```

## Author

[Pritesh Nimje](mailto:nimje.p@northeastern.edu)