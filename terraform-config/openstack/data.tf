## Get Image ID
data "openstack_images_image_v2" "image" {
  name        = "centos7" # Name of image to be used
  most_recent = true
}

## Get flavor id
data "openstack_compute_flavor_v2" "flavor" {
  name = "kube_nodes" # flavor to be used
}

data "template_file" "user_data" {
  template = file("../openstack/ssh-script.yaml")
}

data "openstack_networking_subnet_v2" "bastion_subnet" {
  name = "mgmt"
}

data "openstack_networking_network_v2" "cluster_network" {
  name = var.network
}
