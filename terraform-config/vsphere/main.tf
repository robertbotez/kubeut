##vSphere VMs

resource "vsphere_folder" "folder" {
  path          = "kubeut-test"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "master" {
  name             = "master${count.index+1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.folder.path

  num_cpus = 4
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  count    = var.master_nodes_count
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
	host_name = "master${count.index+1}"
	domain    = "test-internal"
      }
      network_interface {
      }
    }
  }

    connection {
      type     = "ssh"
      user     = ""
      password = ""
      #host     = vsphere_virtual_machine.vm01.default_ip_address
    }
}

resource "vsphere_virtual_machine" "workers" {
  name             = "worker${count.index+1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.folder.path
  num_cpus = 4
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  count	   = var.workers_nodes_count

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id


    customize {
      linux_options {
	host_name = "worker${count.index+1}"
	domain    = "test-internal"
      }
      network_interface {
      }
    }
  }

    connection {
      type     = "ssh"
      user     = ""
      password = ""
      #host     = vsphere_virtual_machine.vm01.default_ip_address
    }
}

resource "vsphere_virtual_machine" "bastions" {
  name             = "bastion${count.index+1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.folder.path

  num_cpus = 4
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  count	   = var.bastions_nodes_count

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id


    customize {
      linux_options {
	host_name = "bastion${count.index+1}"
	domain    = "test-internal"
      }
      network_interface {
      }
    }
  }

    connection {
      type     = "ssh"
      user     = ""
      password = ""
      #host     = vsphere_virtual_machine.vm01.default_ip_address
    }
}

resource "null_resource" "provision_master_member_hosts_file" {

  # Changes to any instance of the master cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", vsphere_virtual_machine.master.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Master members:\" }; { print $0 \" ${var.master_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", vsphere_virtual_machine.master.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Master members:\" }; { print $0 \" ${var.master_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
  }
  triggers = {
    cluster_instance_ids = join(",", vsphere_virtual_machine.master.*.id)
    #build_number = "${timestamp()}"
  }
}

resource "null_resource" "provision_worker_member_hosts_file" {

  # Changes to any instance of the workers cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", vsphere_virtual_machine.workers.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Worker members:\" }; { print $0 \" ${var.worker_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", vsphere_virtual_machine.workers.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Worker members:\" }; { print $0 \" ${var.worker_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
    }
  triggers = {
    cluster_instance_ids = join(",", vsphere_virtual_machine.workers.*.id)
    #build_number = "${timestamp()}"
  }
}

resource "null_resource" "provision_bastion_member_hosts_file" {

  # Changes to any instance of the workers cluster requires re-provisioning
  provisioner "local-exec" {
    command = "echo '${join("\n", formatlist("%v", vsphere_virtual_machine.bastions.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Bastion members:\" }; { print $0 \" ${var.bastion_member_name_prefix}\" NR }' | sudo tee -a /etc/hosts > /dev/null | echo '${join("\n", formatlist("%v", vsphere_virtual_machine.bastions.*.default_ip_address))}' | awk 'BEGIN{ print \"\\n\\n# Bastion members:\" }; { print $0 \" ${var.bastion_member_name_prefix}\" NR }' | sudo tee -a $KUBEUT/../hosts > /dev/null"
    }
  triggers = {
    cluster_instance_ids = join(",", vsphere_virtual_machine.bastions.*.id)
    #build_number = "${timestamp()}"
  }
}
 ##Output
