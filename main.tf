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
    email  = google_service_account.webapp_vm_service_acc.email
    scopes = var.webapp_vm_service_acc_scopes
  }

  metadata = {
    startup-script = templatefile("scripts/webapp-startup-script.sh.tpl", {
      db_hostname      = google_sql_database_instance.db_instance.private_ip_address
      db_name          = google_sql_database.webapp_db.name
      db_username      = google_sql_user.db_user.name
      db_password      = google_sql_user.db_user.password
      webapp_log_level = var.webapp_log_level
      webapp_log_path  = var.webapp_log_path
    })
  }

  depends_on = [
    google_service_account.webapp_vm_service_acc,
    google_project_iam_binding.webapp_vm_sa_iam_binding
  ]
}

resource "google_service_account" "webapp_vm_service_acc" {
  account_id   = var.webapp_vm_service_account_id
  display_name = var.webapp_vm_service_account_display_name
}

resource "google_project_iam_binding" "webapp_vm_sa_iam_binding" {
  for_each = toset(var.webapp_vm_service_account_roles)

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.webapp_vm_service_acc.email}",
  ]

  depends_on = [google_service_account.webapp_vm_service_acc]
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
