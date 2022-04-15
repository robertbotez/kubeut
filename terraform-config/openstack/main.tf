resource "openstack_networking_port_v2" "vip" {
  count      = "${var.bastion_nodes_count != "0" ? 1 : 0}"
  network_id = data.openstack_networking_network_v2.cluster_network.id

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.bastion_subnet.id
    ip_address = var.vip_port
  }
}

resource "openstack_networking_port_v2" "bastion_ports" {
  count      = var.bastion_nodes_count
  name       = "bastion-ports${count.index+1}"
  network_id = data.openstack_networking_network_v2.cluster_network.id

  allowed_address_pairs {
    ip_address = var.vip_port
  }
}

# Create bastions instance
resource "openstack_compute_instance_v2" "bastion" {
  name            = "bastion${count.index+1}"  #Instance name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  security_groups = var.security_groups
  user_data       = data.template_file.user_data.rendered
  count           = var.bastion_nodes_count

  network {
    name = var.network
    port = "${openstack_networking_port_v2.bastion_ports[count.index].id}"
    }
}


# Create masters instance
resource "openstack_compute_instance_v2" "master" {
  name            = "master${count.index+1}"  #Instance name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  security_groups = var.security_groups
  user_data       = data.template_file.user_data.rendered
  count           = var.master_nodes_count

  network {
    name = var.network
    }
}

# Create workers instance
resource "openstack_compute_instance_v2" "workers" {
  name            = "worker${count.index+1}"  #Instance name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  security_groups = var.security_groups
  user_data       = data.template_file.user_data.rendered
  count           = var.worker_nodes_count

  network {
    name = var.network
  }
}

resource "null_resource" "provision_bastion_member_hosts_file" {

  # Changes to any instance of the master cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.bastion.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Bastion members:\" }; { print $0 \" ${var.bastion_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.bastion.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Bastion members:\" }; { print $0 \" ${var.bastion_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
  }
  /*provisioner "remote-exec" {
    inline = ["echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.bastion.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Bastion members:\" }; { print $0 \" ${var.bastion_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null",]
  }*/
  triggers = {
    cluster_instance_ids = join(",", openstack_compute_instance_v2.bastion.*.id)
    #build_number = "${timestamp()}"
  }
}

resource "null_resource" "provision_master_member_hosts_file" {
  //count = "${var.master_nodes_count}"
  # Changes to any instance of the master cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.master.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Master members:\" }; { print $0 \" ${var.master_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.master.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Master members:\" }; { print $0 \" ${var.master_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
  }
  /*provisioner "remote-exec" {
    inline = ["echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.master.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Master members:\" }; { print $0 \" ${var.master_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null",]
  }*/
  triggers = {
    cluster_instance_ids = join(",", openstack_compute_instance_v2.master.*.id)
    #build_number = "${timestamp()}"
  }
}

resource "null_resource" "provision_worker_member_hosts_file" {

  # Changes to any instance of the workers cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.workers.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Worker members:\" }; { print $0 \" ${var.worker_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.workers.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Worker members:\" }; { print $0 \" ${var.worker_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
    }
  /*provisioner "remote-exec" {
    inline = ["echo '${join("\n", formatlist("%v", openstack_compute_instance_v2.workers.*.access_ip_v4))}' | awk 'BEGIN{ print \"\\n\\n# Worker members:\" }; { print $0 \" ${var.worker_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null",]
    }*/
  triggers = {
    cluster_instance_ids = join(",", openstack_compute_instance_v2.workers.*.id)
    #build_number = "${timestamp()}"
  }
}
