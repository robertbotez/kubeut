##Provider

provider "vsphere" {
  user           = var.cloud_username
  password       = var.cloud_password
  vsphere_server = ""

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
