variable "environment" {
  type        = string
  description = "Environment for infra"
}

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "vpc_routing_mode" {
  type        = string
  description = "Routing mode for the vpc network"
}

variable "internet_gateway_cidr" {
  type        = string
  description = "Route destination ip address range for internet gateway"
}

variable "webapp_subnet_name" {
  type        = string
  description = "Webapp subnet name"
}

variable "db_subnet_name" {
  type        = string
  description = "Database subnet name"
}

variable "webapp_subnet_cidr" {
  type        = string
  description = "Webapp subnet CIDR block"
}

variable "db_subnet_cidr" {
  type        = string
  description = "Database subnet CIDR block"
}

variable "allow_http_ports" {
  type        = list(string)
  description = "List of allowed ports for incoming http traffic"
}

variable "allow_http_source_ranges" {
  type        = list(string)
  description = "List of source ip ranges for incoming http traffic"
}

variable "allow_http_target_tags" {
  type        = list(string)
  description = "List of network tags of target instance"
}

variable "allow_http_disabled" {
  type        = bool
  description = "Disable allow http firewall rule"
}

variable "deny_ssh_ports" {
  type        = list(string)
  description = "List of denied ports for incoming ssh traffic"
}

variable "deny_ssh_source_ranges" {
  type        = list(string)
  description = "List of source ip ranges for incoming ssh traffic"
}

variable "deny_ssh_target_tags" {
  type        = list(string)
  description = "List of network tags of target instance"
}

variable "deny_ssh_disabled" {
  type        = bool
  description = "Disable deny ssh firewall rule"
}

variable "webapp_instance_name" {
  type        = string
  description = "Name for the webapp instance"
}

variable "webapp_instance_machine_type" {
  type        = string
  description = "Preset GCE machine type for the webapp instance"
}

variable "webapp_instance_zone" {
  type        = string
  description = "Zone where the webapp instance should be created"
}

variable "webapp_instance_tags" {
  type        = list(string)
  description = "List of network tags to attach to the webapp instance"
}

variable "webapp_instance_disk_type" {
  type        = string
  description = "Disk type to attach to the webapp instance"
}

variable "webapp_instance_image_name" {
  type        = string
  description = "Image name or image family name to initialize boot disk for the webapp instance"
}

variable "webapp_instance_disk_size" {
  type        = string
  description = "Disk size to attach to the webapp instance"
}

variable "webapp_instance_network_tier" {
  type        = string
  description = "Network tier of the webapp instance"
}

variable "db_instance_database_version" {
  type        = string
  description = "Database version of the cloud sql instance"
}

variable "db_instance_deletion_protection" {
  type        = string
  description = "Whether or not to allow Terraform to destroy the cloud sql instance"
}

variable "db_instance_tier" {
  type        = string
  description = "Machine type of the cloud sql instance"
}

variable "db_instance_disk_size" {
  type        = string
  description = "Disk size to attach to the cloud sql instance"
}

variable "db_instance_disk_type" {
  type        = string
  description = "Disk type to attach to the cloud sql instance"
}

variable "db_instance_availability_type" {
  type        = string
  description = "The availability type of the cloud sql instance"
}

variable "db_name" {
  type        = string
  description = "Name of the database to create in cloud sql instance"
}

variable "db_username" {
  type        = string
  description = "Username for the database user in cloud sql instance"
}

variable "private_ip_address_purpose" {
  type        = string
  description = "Purpose of the private IP address for the vpc network connection"
}

variable "private_ip_address_type" {
  type        = string
  description = "Address type of the private IP address for the vpc network connection"
}