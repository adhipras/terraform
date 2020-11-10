variable "credentials" {
  description = "The service account key file."
  type        = string
  default     = "credentials.json"
}

variable "project_id" {
  description = "The project ID."
  type        = string
  default     = "gcp-free-tier-293108"
}

variable "region" {
  description = "The location of regional resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The location of zonal resources."
  type        = string
  default     = "us-central1-a"
}

variable "public_network_cidr_source_ranges" {
  description = "The IP address range of the public network source ranges in CIDR notation."
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "private_subnetwork_cidr_range" {
  description = "The IP address range of the private subnetwork in CIDR notation."
  type        = string
  default     = "10.0.0.0/16"
}
