provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
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

resource "google_compute_subnetwork" "vpc_subnet_private" {
  name                     = "${var.project_id}-subnet-private"
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = var.private_subnetwork_cidr_range
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

data "google_compute_image" "vm_image" {
  project = "centos-cloud"
  family  = "centos-8"
}

resource "google_compute_instance" "vm_centos" {
  name         = "${var.project_id}-vm-centos"
  zone         = data.google_compute_zones.available.names[0]
  machine_type = "f1-micro"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vm_image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.vpc_subnet_private.self_link
  }

  scheduling {
    automatic_restart = false
    preemptible       = true
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "${var.project_id}-fw-ssh"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = var.public_network_cidr_source_ranges
  target_tags   = ["ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}