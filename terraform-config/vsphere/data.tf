##Data

data "vsphere_datacenter" "dc" {
  name = "CLOUD UTCN"
}

data "vsphere_datastore" "datastore" {
  name          = "VMware_Compute_Hybrid_Lun1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "COMPUTE"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "vLAN 207 Private"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu20-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}
