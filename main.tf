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

// images OS see on module for full-list
 images =   ["centos7", "opensuse423"]
}

// ctl is based on opensuse423

module "ctl" {
  source = "./modules/libvirt/controller"
  base_configuration = "${module.base.configuration}"
  name = "ctl"
}
