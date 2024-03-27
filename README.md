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
- Cloud Logging API (`logging.googleapis.com`)
- Serverless VPC Access API (`vpcaccess.googleapis.com`)
- Cloud Build API (`cloudbuild.googleapis.com`)
- Cloud Functions API (`cloudfunctions.googleapis.com`)
- Cloud Pub/Sub API (`pubsub.googleapis.com`)
- Cloud Pub/Sub API (`pubsub.googleapis.com`)
- Cloud Run Admin API (`run.googleapis.com`)
- Eventarc API (`eventarc.googleapis.com`)

 ## Configuration with tfvars

To configure infrastructure for different environments (eg dev, stage, prod):

- Create a env.tfvars file (eg, dev.tfvars, prod.tfvars, etc)
- Sample env.tfvars file:
```hcl
    environment                  = "dev"
    project_id                   = "gcp project id"
    region                       = "gcp region"
    webapp_subnet_name           = "webapp subnet"
    webapp_subnet_cidr_block     = "xxx.xxx.x.x/xx"
    db_subnet_name               = "db subnet"
    db_subnet_cidr_block         = "xxx.xxx.x.x/xx"
    vpc_routing_mode             = "REGIONAL"
    internet_gateway_cidr        = "x.x.x.x/x"
    allow_http_ports             = ["8080"]
    allow_http_source_ranges     = ["x.x.x.x/x"]
    allow_http_target_tags       = ["webapp", "allow-http"]
    allow_http_disabled          = false
    deny_ssh_ports               = ["22"]
    deny_ssh_source_ranges       = ["x.x.x.x/x"]
    deny_ssh_target_tags         = ["webapp", "deny-ssh"]
    deny_ssh_disabled            = false
    webapp_instance_name         = "webapp-vm"
    webapp_instance_machine_type = "gce machine type"
    webapp_instance_zone         = "gcp zone"
    webapp_instance_tags         = ["webapp", "allow-http", "allow-ssh"]
    webapp_instance_disk_size    = 100
    webapp_instance_disk_type    = "pd-balanced"
    webapp_instance_image_name   = "xxxxxxx" # could either be image name or image family name
    webapp_instance_network_tier = "PREMIUM"
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