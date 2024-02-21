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
  ip_cidr_range = var.webapp_subnet_cidr_block
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.db_subnet_cidr_block
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

resource "google_compute_instance" "webapp_vm" {
  name         = "${var.environment}-${var.webapp_instance_name}"
  machine_type = var.webapp_instance_machine_type
  zone         = var.webapp_instance_zone
  tags         = var.webapp_instance_tags

  boot_disk {
    initialize_params {
      image = var.webapp_instance_image_name
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
}
