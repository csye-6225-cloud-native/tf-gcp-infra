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

variable "webapp_subnet_cidr" {
  type        = string
  description = "Webapp subnet CIDR block"
}

variable "db_subnet_name" {
  type        = string
  description = "Database subnet name"
}

variable "db_subnet_cidr" {
  type        = string
  description = "Database subnet CIDR block"
}

# variable "webapp_lb_subnet_name" {
#   type        = string
#   description = "Webapp load balancer subnet name"
# }

# variable "webapp_lb_subnet_cidr" {
#   type        = string
#   description = "Webapp load balancer subnet CIDR block"
# }

variable "allow_health_check_ports" {
  type        = list(string)
  description = "List of allowed ports for incoming https traffic"
}

variable "allow_health_check_source_ranges" {
  type        = list(string)
  description = "List of source ip ranges for incoming https traffic"
}

variable "allow_health_check_target_tags" {
  type        = list(string)
  description = "List of network tags of target instance"
}

variable "deny_internet_ports" {
  type        = list(string)
  description = "List of denied ports for incoming internet traffic"
}

variable "deny_internet_source_ranges" {
  type        = list(string)
  description = "List of source ip ranges for incoming internet traffic"
}

variable "deny_internet_target_tags" {
  type        = list(string)
  description = "List of network tags of target instance"
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

variable "webapp_instance_name" {
  type        = string
  description = "Name for the webapp instance"
}

variable "webapp_instance_description" {
  type        = string
  description = "Description for the webapp instance "
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

variable "webapp_dns_zone_name" {
  type        = string
  description = "Zone name of the webapp cloud dns"
}

variable "webapp_dns_record_set_ttl" {
  type        = number
  description = "time-to-live of the webapp dns record set"
}

variable "webapp_vm_service_account_id" {
  type        = string
  description = "Account ID for the service account to be created for the webapp instance"
}

variable "webapp_vm_service_account_display_name" {
  type        = string
  description = "Display name for the service account to be created for the webapp instance"
}

variable "webapp_vm_service_account_roles" {
  type        = list(string)
  description = "List of IAM roles to attach to the service account for the webapp instance"
}

variable "webapp_vm_service_account_scopes" {
  type        = list(string)
  description = "List of scopes for the service account attached to the webapp instance"
}

variable "webapp_log_level" {
  type        = string
  description = "Minimum log level for the webapp logs"
}

variable "webapp_log_path" {
  type        = string
  description = "Default log path for the webapp logs"
}

variable "webapp_domain" {
  type        = string
  description = "Domain name of the webapp"
}

variable "webapp_port" {
  type        = number
  description = "Port of the webapp"
}

variable "mailgun_api_key" {
  type        = string
  description = "API Key for the mailgun client for the gcf service config"
}

variable "verify_email_pubsub_topic_name" {
  type        = string
  description = "Name of the email verification pubsub topic"
}

variable "verify_email_pubsub_topic_retention_duration" {
  type        = string
  description = "Message retention duration in seconds for the verify email pubsub topic"
}

variable "pubsub_service_account_token_creator_role" {
  type        = string
  description = "Service account token creator role to attach to the google's managed pubsub service account"
}

variable "verify_email_pubsub_sub_name" {
  type        = string
  description = "Name of the email verification pubsub subscription"
}

variable "verify_email_pubsub_sub_retention_duration" {
  type        = string
  description = "Message retention duration in seconds for the verify email pubsub subscription"
}

variable "verify_email_pubsub_sub_ack_deadline" {
  type        = number
  description = "Acknowledge deadline in seconds for the verify email pubsub subscription"
}

variable "verify_email_pubsub_sub_min_backoff" {
  type        = string
  description = "Minimun backoff delay in seconds for the verify email pubsub subscription"
}

variable "verify_email_pubsub_sub_max_backoff" {
  type        = string
  description = "Maximum backoff delay in seconds for the verify email pubsub subscription"
}

variable "gcf_vpc_connector_cidr_range" {
  type        = string
  description = "Serverless vpc access connector's CIDR block"
}

variable "gcf_service_account_display_name" {
  type        = string
  description = "Display name for the service account to be created for the cloud function"
}

variable "gcf_service_account_member_roles" {
  type        = list(string)
  description = "List of IAM roles for the service account member to be created for the cloud function"
}

variable "gcf_service_account_cloudfunctions_member_role" {
  type        = string
  description = "Cloudfunction2 IAM role for the service account member to be created for the cloud function"
}

variable "verify_email_gcf_name" {
  type        = string
  description = "Name of the verify email cloud function"
}

variable "verify_email_gcf_build_runtime" {
  type        = string
  description = "Build runtime of the verify email cloud function"
}

variable "verify_email_gcf_build_entry_point" {
  type        = string
  description = "Entry point of the verify email cloud function"
}

variable "verify_email_gcf_service_min_instance" {
  type        = number
  description = "Minimun instance count of the verify email cloud function"
}

variable "verify_email_gcf_service_max_instance" {
  type        = number
  description = "Maximum instance count of the verify email cloud function"
}

variable "verify_email_gcf_service_available_memory" {
  type        = string
  description = "Memory to allocate to the instance of the verify email cloud function"
}

variable "verify_email_gcf_service_timeout_seconds" {
  type        = number
  description = "Service timeout in seconds of the verify email cloud function"
}

variable "verify_email_gcf_service_ingress_settings" {
  type        = string
  description = "Service ingress setting of the verify email cloud function"
}

variable "verify_email_gcf_event_type" {
  type        = string
  description = "Event trigger type of the verify email cloud function"
}

variable "verify_email_gcf_event_retry_policy" {
  type        = string
  description = "Event trigger retry policy of the verify email cloud function"
}

variable "verify_email_gcf_service_vpc_egress_settings" {
  type        = string
  description = "VPC access connector egress setting for the verify email cloud function"
}

variable "verify_email_gcf_source_storage_object_name" {
  type        = string
  description = "Storage object name of the verify email cloud function source"
}

variable "webapp_http_health_check_name" {
  type        = string
  description = "Name of the http health check for the webapp instance"
}

variable "webapp_http_health_check_description" {
  type        = string
  description = "Description of the http health check for the webapp instance"
}

variable "webapp_http_health_check_interval_sec" {
  type        = number
  description = "Interval in seconds to send a health check request to the webapp instance"
}

variable "webapp_http_health_check_timeout_sec" {
  type        = number
  description = "Timeout in seconds to consider a health check response failure from the webapp instance"
}

variable "webapp_http_health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive successful requests to consider webapp instance healthy"
}

variable "webapp_http_health_check_unhealthy_threshold" {
  type        = number
  description = "Number of consecutive failed requests to consider webapp instance unhealthy"
}

variable "webapp_http_health_check_port" {
  type        = string
  description = "Port of the health check endpoint of the webapp instance"
}

variable "webapp_http_health_check_request_path" {
  type        = string
  description = "Request path of the health check endpoint of the webapp instance"
}

variable "webapp_instance_template_description" {
  type        = string
  description = "Description of the webapp instance template"
}

variable "webapp_mig_distribution_policy_zones" {
  type        = list(string)
  description = "List of allowed zones for the webapp instance group"
}

variable "webapp_mig_distribution_policy_target_shape" {
  type        = string
  description = "Distribution strategy of the webapp instance group"
}

variable "webapp_mig_named_port_name" {
  type        = string
  description = "Name of the named port of the webapp instance group"
}

variable "webapp_mig_autohealing_initial_delay_sec" {
  type        = number
  description = "The number of seconds that the webapp mig waits before it applies autohealing policies"
}

variable "webapp_mig_autoscaler_name" {
  type        = string
  description = "Name for the autoscaler of the webapp instance MIG"
}

variable "webapp_mig_autoscaler_min_replicas" {
  type        = number
  description = "Minimum number of replicas that the webapp autoscaler can scale down to"
}

variable "webapp_mig_autoscaler_max_replicas" {
  type        = number
  description = "Maximum number of replicas that the webapp autoscaler can scale up to"
}

variable "webapp_mig_autoscaler_cooldown_period" {
  type        = number
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new webapp instance"
}

variable "webapp_mig_autoscaler_cpu_utilization_target" {
  type        = number
  description = "The target CPU utilization that the autoscaler should maintain for webapp instance group"
}

variable "webapp_lb_name" {
  type        = string
  description = "Name of the load balancer for webapp"
}

variable "webapp_lb_backend_service_load_balancing_scheme" {
  type        = string
  description = "Load balancing scheme of the webapp lb"
}

variable "webapp_lb_backend_service_locality_lb_policy" {
  type        = string
  description = "The load balancing algorithm used within the scope of the locality of the webapp lb"
}

variable "webapp_lb_backend_service_protocol" {
  type        = string
  description = "The protocol this used to communicate with webapp instance"
}

variable "webapp_lb_backend_service_port_name" {
  type        = string
  description = "Name of backend port of the webapp instance"
}

variable "webapp_lb_backend_service_session_affinity" {
  type        = string
  description = "Type of session affinity to use for the webapp lb"
}

variable "webapp_lb_backend_service_timeout_sec" {
  type        = number
  description = "How many seconds to wait for the webapp before considering it a failed request"
}

variable "webapp_lb_backend_service_balancing_mode" {
  type        = string
  description = "The balancing mode for the backend service of webapp lb"
}

variable "webapp_lb_backend_service_max_utilization" {
  type        = number
  description = "Maximum CPU utilization target for the backend service of webapp lb"
}

variable "webapp_lb_backend_service_capacity_scaler" {
  type        = number
  description = "A multiplier applied to the group's maximum servicing capacity of the webapp lb"
}

variable "webapp_lb_forwarding_rule_load_balancing_scheme" {
  type        = string
  description = "Load balancing scheme of the forwarding rule of webapp lb"
}

variable "webapp_lb_forwarding_rule_ip_protocol" {
  type        = string
  description = "IP protocol of the forwarding rule of webapp lb"
}

variable "webapp_lb_forwarding_rule_port_range" {
  type        = string
  description = "Port range of the forwarding rule of webapp lb"
}

variable "webapp_ssl_certificate_name" {
  type        = string
  description = "Name of the webapp google-managed ssl certificate"
}

variable "kms_crypto_key_rotation_period" {
  type = string
}

variable "kms_crypto_key_iam_binding_role" {
  type = string
}

variable "instance_kms_crypto_key_name" {
  type = string
}

variable "cloudsql_kms_crypto_key_name" {
  type = string
}

variable "storage_kms_crypto_key_name" {
  type = string
}

variable "gcp_cloudsql_service_identity_service" {
  type = string
}