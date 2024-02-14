resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = "webapp-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "192.168.0.0/24"
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = "db-subnet"
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_route" "custom_route" {
  name             = "custom-route"
  network          = google_compute_network.vpc_network.id
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}