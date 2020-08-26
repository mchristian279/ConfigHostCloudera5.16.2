# Script Proviona Ambiente Cluster Cloudera com 3 VMs
# Autor: Michael Christian
# github: mchristian279

output "Disco" {
  value = libvirt_volume.volume.*.id
}

output "Rede" {
  value = libvirt_network.vm_network.id
}

output "IP" {
  value = libvirt_domain.domain.*.network_interface.0.addresses
}

output "ansible" {
  value = null_resource.ansible
}
