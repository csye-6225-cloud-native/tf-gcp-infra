variable "environment" {
  type        = string
  description = "Environment for infra"
  default     = "dev"
}

variable "project_id" {
  type        = string
  description = "Default project id"
  default     = "csye-6225-cloud-native"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-east1"
}

variable "webapp_cidr_block" {
  description = "Webapp subnet CIDR block"
  type        = string
  default     = "192.168.0.0/24"
}

variable "db_subnet_cidr_block" {
  description = "Database subnet CIDR block"
  type        = string
  default     = "192.168.1.0/24"
}
