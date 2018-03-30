provider "libvirt" {
  uri = "qemu:///system"
}

module "base" {
  source = "./modules/libvirt/base"
  #  UC16 - 5f7a0ab563
  network_name = ""
  bridge = "br0"
  name_prefix = "dma-"
}

module "ctl" {
  source = "./modules/libvirt/controller"
  base_configuration = "${module.base.configuration}"
  name = "ctl"
}
