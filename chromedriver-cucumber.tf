provider "libvirt" {
  uri = "qemu:///system"
}

module "base" {
  source = "./modules/libvirt/base"
  network_name = ""
  bridge = "br0"
  name_prefix = "dma-"
}

module "ctl" {
  source = "./modules/libvirt/controller"
  base_configuration = "${module.base.configuration}"
  name = "ctl"
}
