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