data "google_project" "current_project" {
  project_id = var.project_id
}

resource "google_compute_network" "vpc_network" {
  project                         = var.project_id
  name                            = "${var.environment}-vpc-network"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  routing_mode                    = var.vpc_routing_mode
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.webapp_subnet_cidr
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.db_subnet_cidr
}

resource "google_compute_route" "internet_route" {
  name             = "${var.environment}-internet-route"
  network          = google_compute_network.vpc_network.id
  dest_range       = var.internet_gateway_cidr
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_firewall" "allow_http_rule" {
  project  = var.project_id
  name     = "${google_compute_network.vpc_network.name}-allow-http"
  network  = google_compute_network.vpc_network.id
  disabled = var.allow_http_disabled

  allow {
    protocol = "tcp"
    ports    = var.allow_http_ports
  }

  source_ranges = var.allow_http_source_ranges
  target_tags   = var.allow_http_target_tags
}

resource "google_compute_firewall" "deny_ssh_rule" {
  project  = var.project_id
  name     = "${google_compute_network.vpc_network.name}-deny-ssh"
  network  = google_compute_network.vpc_network.id
  disabled = var.deny_ssh_disabled

  deny {
    protocol = "tcp"
    ports    = var.deny_ssh_ports
  }

  source_ranges = var.deny_ssh_source_ranges
  target_tags   = var.deny_ssh_target_tags
}

data "google_compute_image" "webapp_image" {
  family  = var.webapp_instance_image_name
  project = var.project_id
}

resource "google_compute_instance" "webapp_instance" {
  name         = "${var.environment}-${var.webapp_instance_name}"
  machine_type = var.webapp_instance_machine_type
  zone         = var.webapp_instance_zone
  tags         = var.webapp_instance_tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.webapp_image.self_link
      size  = var.webapp_instance_disk_size
      type  = var.webapp_instance_disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link

    access_config {
      network_tier = var.webapp_instance_network_tier
    }
  }

  service_account {
    email  = google_service_account.webapp_vm_service_account.email
    scopes = var.webapp_vm_service_account_scopes
  }

  metadata = {
    startup-script = templatefile("scripts/webapp-startup-script.sh.tpl", {
      db_hostname                         = google_sql_database_instance.db_instance.private_ip_address
      db_name                             = google_sql_database.webapp_db.name
      db_username                         = google_sql_user.db_user.name
      db_password                         = google_sql_user.db_user.password
      webapp_log_level                    = var.webapp_log_level
      webapp_log_path                     = var.webapp_log_path
      gcp_project_id                      = var.project_id
      gcp_email_verification_pubsub_topic = google_pubsub_topic.verify_email_topic.name
    })
  }

  depends_on = [
    google_service_account.webapp_vm_service_account,
    google_project_iam_binding.webapp_vm_iam_bindings
  ]
}

resource "google_service_account" "webapp_vm_service_account" {
  account_id   = "${var.environment}-${var.webapp_vm_service_account_id}"
  display_name = var.webapp_vm_service_account_display_name
}

resource "google_project_iam_binding" "webapp_vm_iam_bindings" {
  for_each = toset(var.webapp_vm_service_account_roles)

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.webapp_vm_service_account.email}",
  ]

  depends_on = [google_service_account.webapp_vm_service_account]
}

data "google_dns_managed_zone" "webapp_dns_zone" {
  name = var.webapp_dns_zone_name
}

resource "google_dns_record_set" "webapp_a_record" {
  name         = data.google_dns_managed_zone.webapp_dns_zone.dns_name
  type         = "A"
  ttl          = var.webapp_dns_record_set_ttl
  managed_zone = data.google_dns_managed_zone.webapp_dns_zone.name
  rrdatas      = [google_compute_instance.webapp_instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.environment}-private-ip-address"
  purpose       = var.private_ip_address_purpose
  address_type  = var.private_ip_address_type
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "db_instance" {
  name                = "${var.environment}-db-instance-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = var.db_instance_database_version
  deletion_protection = var.db_instance_deletion_protection

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.db_instance_tier
    disk_size         = var.db_instance_disk_size
    disk_type         = var.db_instance_disk_type
    availability_type = var.db_instance_availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
  }
}

resource "google_sql_database" "webapp_db" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.id
}

resource "random_password" "password" {
  length           = 16
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!@#&*-_+<>:?"
}

resource "google_sql_user" "db_user" {
  name     = var.db_username
  instance = google_sql_database_instance.db_instance.id
  password = random_password.password.result
}

resource "google_pubsub_topic" "verify_email_topic" {
  name                       = var.verify_email_pubsub_topic_name
  message_retention_duration = var.verify_email_pubsub_topic_retention_duration
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  name                       = var.verify_email_pubsub_sub_name
  topic                      = google_pubsub_topic.verify_email_topic.id
  ack_deadline_seconds       = var.verify_email_pubsub_sub_ack_deadline
  message_retention_duration = var.verify_email_pubsub_sub_retention_duration
  retry_policy {
    minimum_backoff = var.verify_email_pubsub_sub_min_backoff
    maximum_backoff = var.verify_email_pubsub_sub_max_backoff
  }

  push_config {
    push_endpoint = google_cloudfunctions2_function.verify_email_gcf.url
  }
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "gcf_bucket" {
  name                        = "${var.environment}-${random_id.bucket_prefix.hex}-gcf-source"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_vpc_access_connector" "gcf_vpc_connector" {
  name          = "${var.environment}-gcf-vpc-connector"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.gcf_vpc_connector_cidr_range
}

resource "google_storage_bucket_object" "verify_email_gcf_object" {
  name   = var.verify_email_gcf_source_storage_object_name
  bucket = google_storage_bucket.gcf_bucket.name
  source = "${path.root}/${var.verify_email_gcf_source_storage_object_name}"
}

resource "google_cloudfunctions2_function" "verify_email_gcf" {
  name     = "${var.environment}-${var.verify_email_gcf_name}"
  location = var.region

  build_config {
    runtime     = var.verify_email_gcf_build_runtime
    entry_point = var.verify_email_gcf_build_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.gcf_bucket.name
        object = google_storage_bucket_object.verify_email_gcf_object.name
      }
    }
  }

  service_config {
    min_instance_count = var.verify_email_gcf_service_min_instance
    max_instance_count = var.verify_email_gcf_service_max_instance
    available_memory   = var.verify_email_gcf_service_available_memory
    timeout_seconds    = var.verify_email_gcf_service_timeout_seconds
    environment_variables = {
      APP_DOMAIN         = var.webapp_domain
      APP_PORT           = var.webapp_port
      DB_NAME            = google_sql_database.webapp_db.name
      DB_USERNAME        = google_sql_user.db_user.name
      DB_PASSWORD        = google_sql_user.db_user.password
      DB_CONNECTION_NAME = google_sql_database_instance.db_instance.connection_name
      MAILGUN_API_KEY    = var.mailgun_api_key
      DB_HOST            = google_sql_database_instance.db_instance.private_ip_address
    }
    ingress_settings      = var.verify_email_gcf_service_ingress_settings
    service_account_email = google_service_account.gcf_service_account.email
    vpc_connector         = google_vpc_access_connector.gcf_vpc_connector.id
  }

  event_trigger {
    event_type   = var.verify_email_gcf_event_type
    pubsub_topic = google_pubsub_topic.verify_email_topic.id
    retry_policy = var.verify_email_gcf_event_retry_policy
  }
}

resource "google_service_account" "gcf_service_account" {
  account_id   = "${var.environment}-gcf-sa"
  display_name = var.gcf_service_account_display_name
}

resource "google_project_iam_member" "gcf_service_account_iam_members" {
  for_each   = toset(var.gcf_service_account_member_roles)
  project    = var.project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.gcf_service_account.email}"
  depends_on = [google_service_account.gcf_service_account]
}

resource "google_cloudfunctions2_function_iam_member" "gcf_service_account_cloudfunctions_invoker" {
  project        = google_cloudfunctions2_function.verify_email_gcf.project
  location       = google_cloudfunctions2_function.verify_email_gcf.location
  cloud_function = google_cloudfunctions2_function.verify_email_gcf.name
  role           = var.gcf_service_account_cloudfunctions_member_role
  member         = "serviceAccount:${google_service_account.gcf_service_account.email}"
}

resource "google_project_iam_binding" "pubsub_service_account_token_creator" {
  project = var.project_id
  role    = var.pubsub_service_account_token_creator_role

  members = [
    "serviceAccount:service-${data.google_project.current_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
}
