provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

data "google_compute_zones" "available" {
  project = var.project_id
}

resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name    = "${var.project_id}-router"
  network = google_compute_network.vpc.self_link
}

resource "google_compute_subnetwork" "vpc_subnet_public" {
  name                     = "${var.project_id}-subnet-public"
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = "10.0.0.0/16"
}

resource "google_compute_subnetwork" "vpc_subnet_private" {
  name                     = "${var.project_id}-subnet-private"
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = "10.1.0.0/16"
}

resource "google_compute_router_nat" "vpc_nat" {
  name                               = "${var.project_id}-nat"
  router                             = google_compute_router.vpc_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnet_private.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_instance" "vm_centos" {
  name         = "${var.project_id}-vm-centos"
  zone         = data.google_compute_zones.available.names[0]
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "centos-8-v20201014"
    }
  }

  network_interface {
    network = google_compute_subnetwork.vpc_subnet_private.self_link
  }
}