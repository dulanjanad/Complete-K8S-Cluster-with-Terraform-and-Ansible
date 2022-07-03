variable "cidr" {
  type        = string
  description = "VPC Name"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "current_public_ip" {
  type        = string
  description = "Current Public IP of my Broadband provider"
}
variable "worker_nodes_count" {
  type        = number
  description = "Number of worker nodes to be provisioned"
}

variable "ubuntu_ami" {
  type        = string
  description = "Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2022-06-10"
}

variable "control_node_instance_type" {
  type        = string
  description = "Instance type for Kubernetes control node"
}

variable "worker_node_instance_type" {
  type        = string
  description = "Instance type for Kubernetes worker node(s)"
}