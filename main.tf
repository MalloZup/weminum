provider "libvirt" {
  uri = "qemu:///system"
}

module "base" {
  source = "./modules/libvirt/base"
// **  have a look at modules/libvirt/base/variables.tf  for variable definition
//  network_name = ""
//  bridge = ""
// ** use you username as prefix
  name_prefix = "dma-"
}

module "ctl" {
  source = "./modules/libvirt/controller"
  base_configuration = "${module.base.configuration}"
  name = "ctl"
}
