# Script Provisiona Ambiente Cluster Cloudera com 3 VMs
# Autor: Michael Christian
# github: mchristian279

variable "instance_count" {
  default = "3"
}

variable "disk_img" {
  default = "file:///Dados/Vms/centos7.0"
}

variable "vm_network_addresses" {
  description = "Configura Rede"
  default     = "192.168.10.0/24"
}

variable "vm_addresses" {
  default = {
    "0" = "192.168.10.10"
    "1" = "192.168.10.11"
    "2" = "192.168.10.12"
  }

}

variable "vm_network_name" {
  description = "Define o nome da rede no KVM"
  default     = "clustercloudera"
}

variable "domain_name" {
  default = "lab.local"
}
