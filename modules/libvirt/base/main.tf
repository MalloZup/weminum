terraform {
    required_version = ">= 0.10.7"
}

resource "libvirt_volume" "volumes" {
  name = "${var.name_prefix}${element(var.images, count.index)}"
  source = "${var.image_locations["${element(var.images, count.index)}"]}"
  count = "${length(var.images)}"
  pool = "${var.pool}"
}

output "configuration" {
  depends_on = ["libvirt_volume.volumes"]
  value = {
    ssh_key_path = "${var.ssh_key_path}"
    use_avahi = "${var.use_avahi}"
    domain = "${var.domain}"
    name_prefix = "${var.name_prefix}"

    // Provider-specific variables
    pool = "${var.pool}"
    network_name = "${var.bridge == "" ? var.network_name : ""}"
    bridge = "${var.bridge}"
  }
}
