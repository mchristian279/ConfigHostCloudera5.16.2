# Provisionar e Configurar Ambiente Cloudera5.16.2

Provisionamento de 3 hosts em ambiente KVM via terraform e ansible-playbook para configuração dos hosts Cloudera 5.16.2.

### Tecnologias Utilizadas:
- Terraform
- Ansible
- Linux
- KVM

### Pré requisitos:
- KVM libvirt
- golang v1.13
- Terraform v0.12
- Plugin terraform-provider-libvirt

### Terraform:
- machine.tf
- output.tf
- variables.tf

### Ansible:
- playbook.yml
- inventory.hosts

### Como Utilizar:

*variables.tf* este arquivo de variáveis permitirá realizar as personalizações necessárias para adaptação de outras necessidades. Abaixo uma breve explicação:

Variável responsável por definir o número de vms a serem provisionadas:
```terraform
variable "instance_count" {
  default = "3"
}
```
Variável responsável por definir a imagem base do S.O (qcow2):
```terraform
variable "disk_img" {
  default = "file:///Dados/Vms/centos7.0"
}
```
Variável responsável por definir a rede a ser provisionada:
```terraform
variable "vm_network_addresses" {
  description = "Configura Rede"
  default     = "192.168.10.0/24"
}
```
Variável responsável por definir o ip estático das vms (OBS: existem 3 ips pois, a variável instance_count foi definida com o valor 3):
```terraform
variable "vm_addresses" {
  default = {
    "0" = "192.168.10.10"
    "1" = "192.168.10.11"
    "2" = "192.168.10.12"
  }

}
```
Variável responsável por definir o nome da rede a ser provisionada no KVM:
```terraform
variable "vm_network_name" {
  description = "Define o nome da rede no KVM"
  default     = "clustercloudera"
}
```
Variável responsável por definir o domínio dos hosts:
```terraform
variable "domain_name" {
  default = "lab.local"
}
```
Variável retornar o id da execução do ansible playbook e a key trigger:
```terraform
output "ansible" {
  value = null_resource.ansible
}
```

### Provisionar Vms Terraform:

validar a estrutura dos arquivos terraform:
</br>
`$ terraform validate`

revisar o plano de execução:
</br>
`$ terraform plan`

provisionar ambiente:
</br>
`$ terraform apply -auto-approve`

resultado esperado:

![](imgs_repo/deployTerraformResult.png)

> OBS:foi cadastrado previamente no arquivo /etc/hosts da estação de trabalho que dispara os scripts de provisiomaneto do ambiente os ips e nomes dos hosts:
</br>

192.168.10.10 cloudera0
</br>
192.168.10.11 cloudera1
</br>
192.168.10.12 cloudera2

<<<<<<< HEAD
=======
### Aplicar Configurações Ansible:

aplicar ansible-playbook:
</br>
`$ ansible-playbook -i inventory.hosts playbook.yml -u root -k`

resultado esperado após aplicar o ansible-playbook:

![](imgs_repo/ansible-playbook-p1.png)
![](imgs_repo/ansible-playbook-p2.png)

>>>>>>> 624283a1c4f0f6c97d4c344df4536c54ecc0afcc
### KVM:

Resultado do provisionamento dos hosts KVM

rede provisionada:

![](imgs_repo/kvm-network.png)

vms provisionadas:

![](imgs_repo/kvm-result.png)

