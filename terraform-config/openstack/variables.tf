variable "network" {
  type    = string
  default = "mgmt"
}

variable "vip_port" {
  type    = string
  default = "10.60.60.254"
}

variable "security_groups" {
  type    = list(string)
  default = ["default"]  # Name of default security group
}

variable "bastion_nodes_count" {
  default = "2"
}

variable "master_nodes_count" {
  default = "3"
}

variable "worker_nodes_count" {
  default = "1"
}

variable "bastion_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default     = "bastion"
}

variable "master_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default     = "master"
}

variable "worker_member_name_prefix" {
  description = "Prefix to use when naming cluster members"
  default     = "worker"
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
