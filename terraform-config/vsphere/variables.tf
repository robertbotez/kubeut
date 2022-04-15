variable "master_nodes_count" {
  default = "1"
}

variable "workers_nodes_count" {
  default = "4"
}

variable "bastions_nodes_count" {
  default = "0"
}

variable "master_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default = "master"
}

variable "worker_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default = "worker"
}

variable "bastion_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default = "bastion"
}

variable "cloud_password" {
  description = "password for cloud user"
  type        = string
  sensitive   = true
}

variable "cloud_username" {
  description = "username for cloud user"
  type        = string
  sensitive   = true
}
