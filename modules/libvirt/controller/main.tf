module "controller" {
  source = "../host"

  base_configuration = "${var.base_configuration}"
  name = "${var.name}"
  ssh_key_path = "${var.ssh_key_path}"
  grains = <<EOF

role: controller

EOF

  // Provider-specific variables
  image = "opensuse423"
  memory = "${var.memory}"
  mac = "${var.mac}"
}
