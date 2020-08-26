# Script Provisiona Ambiente Cluster Cloudera com 3 VMs
# Autor: Michael Christian
# github: mchristian279

#Provider
provider "libvirt" {
  uri = "qemu:///system"
}

#Imagem
resource "libvirt_volume" "os_image" {
  name   = "os_image"
  pool   = "Dados"
  source = var.disk_img
}

#Volume
resource "libvirt_volume" "volume" {
  name           = "cloudera-${count.index}"
  pool           = "Dados"
  base_volume_id = libvirt_volume.os_image.id
  count          = var.instance_count
}

#Rede
resource "libvirt_network" "vm_network" {

  name      = var.vm_network_name
  addresses = ["${var.vm_network_addresses}"]
  domain    = var.domain_name
  mode      = "nat"
  dhcp {
    enabled = false
  }

  dns {
    local_only = true
  }

  autostart = true
}

#VM
resource "libvirt_domain" "domain" {
  name   = "cloudera-${count.index}"
  memory = "8024"
  vcpu   = "2"

  network_interface {
    network_id     = libvirt_network.vm_network.id
    hostname       = "cloudera-${count.index}"
    addresses      = ["${var.vm_addresses[count.index]}"]
    wait_for_lease = true

  }

  disk {
    volume_id = libvirt_volume.volume[count.index].id
  }
  count = var.instance_count
}

#Ansible
resource "null_resource" "ansible" {
  triggers = {
    key = "${uuid()}"
  }
  depends_on = [libvirt_domain.domain]
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.hosts -u root playbook.yml --private-key=./key/id_rsa.pem -u root"
  }
}
