# Terraform

[HashiCorp](https://www.hashicorp.com/)'s [Terraform](https://www.terraform.io/) configuration files usable for [Google Cloud Platform](https://cloud.google.com/) [Free Tier products](https://cloud.google.com/free).

This configuration file will provision:
* a VPC network in Iowa (us-central1) region
* a private subnetwork
* a cloud router
* a cloud NAT for allowing the Google Compute Engine instance to access the Internet while not having a public IP address
* an f1-micro Google Compute Engine preemptive instance with CentOS 8 image
* a firewall rule for allowing SSH to the instance
* an output for gcloud SSH command used to SSH into the instance

## Usage

```sh
$ cd google-free-tier
$ terraform init
$ terraform plan
$ terraform apply
```
