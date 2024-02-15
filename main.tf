resource "google_compute_network" "vpc_network" {
  project                         = var.project_id
  name                            = "${var.environment}-vpc-network"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = "${var.environment}-webapp-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.webapp_cidr_block
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = "${var.environment}-db-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = var.db_subnet_cidr_block
}

resource "google_compute_route" "custom_route" {
  name             = "${var.environment}-route"
  network          = google_compute_network.vpc_network.id
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}