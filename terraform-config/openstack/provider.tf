# Configure the OpenStack Provider

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  user_name           = var.cloud_username
  tenant_name         = ""
  password            = var.cloud_password
  auth_url            = ""
  region              = ""
  user_domain_name    = ""
  project_domain_name = ""
}
