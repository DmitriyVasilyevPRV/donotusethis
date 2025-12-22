locals {
  create_vpc  = length(var.existing_vpc_name) == 0
}

data "google_compute_network" "existing_vpc" {
  count = local.create_vpc ? 0 : 1
  name  = var.existing_vpc_name
}

data "google_compute_subnetwork" "existing_subnet" {
  count   = local.create_vpc ? 0 : 1
  name    = var.existing_subnet_name
  region  = var.region
}

resource "google_compute_network" "vpc" {
  count                    = local.create_vpc ? 1 : 0
  name                     = "${var.goog_cm_deployment_name}-vpc"
  auto_create_subnetworks  = false
}

resource "google_compute_subnetwork" "subnet" {
  count         = local.create_vpc ? 1 : 0
  name          = "${var.goog_cm_deployment_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc[0].id
  ip_cidr_range = var.subnet_ip_cidr_range
}
