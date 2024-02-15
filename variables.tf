variable "environment" {
  type        = string
  description = "Environment for infra"
}

variable "project_id" {
  type        = string
  description = "Default project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "webapp_subnet_name" {
  type        = string
  description = "Webapp subnet name"
}

variable "db_subnet_name" {
  type        = string
  description = "Database subnet name"
}

variable "webapp_subnet_cidr_block" {
  type        = string
  description = "Webapp subnet CIDR block"
}

variable "db_subnet_cidr_block" {
  type        = string
  description = "Database subnet CIDR block"
}
