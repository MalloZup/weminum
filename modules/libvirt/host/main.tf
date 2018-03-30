terraform {
    required_version = ">= 0.10.7"
}

// Names are calculated as follows:
// ${var.base_configuration["name_prefix"]}${var.name}${var.count > 1 ? "-${count.index  + 1}" : ""}
// This means:
//   name_prefix + name (if count = 1)
//   name_prefix + name + "-" + index (if count > 1)

resource "libvirt_volume" "main_disk" {
  name = "${var.base_configuration["name_prefix"]}${var.name}${var.count > 1 ? "-${count.index  + 1}" : ""}-main-disk"
  base_volume_name = "${var.base_configuration["name_prefix"]}${var.image}"
  pool = "${var.base_configuration["pool"]}"
  count = "${var.count}"
}

resource "libvirt_domain" "domain" {
  name = "${var.base_configuration["name_prefix"]}${var.name}${var.count > 1 ? "-${count.index  + 1}" : ""}"
  memory = "${var.memory}"
  vcpu = "${var.vcpu}"
  count = "${var.count}"

  // base disk + additional disks if any
  disk = ["${concat(
    list(
      map("volume_id", "${element(libvirt_volume.main_disk.*.id, count.index)}")
    ),
    var.additional_disk
  )}"]

  network_interface {
    wait_for_lease = true
    network_name = "${var.base_configuration["network_name"]}"
    bridge = "${var.base_configuration["bridge"]}"
    mac = "${var.mac}"
  }

  connection {
    user = "root"
    password = "linux"
  }

  provisioner "file" {
    source = "salt"
    destination = "/root"
  }

  provisioner "file" {
    content = <<EOF

hostname: ${var.base_configuration["name_prefix"]}${var.name}${var.count > 1 ? "-${count.index  + 1}" : ""}
domain: ${var.base_configuration["domain"]}
use_avahi: ${var.base_configuration["use_avahi"]}
authorized_keys: [${trimspace(file(var.base_configuration["ssh_key_path"]))},${trimspace(file(var.ssh_key_path))}]
reset_ids: true
${var.grains}

EOF

    destination = "/etc/salt/grains"
  }

  provisioner "remote-exec" {
    inline = [
      "salt-call --local --file-root=/root/salt/ --output=quiet state.sls default",
      "salt-call --local --file-root=/root/salt/ --log-level=info --force-color state.highstate"
    ]
  }
}

output "configuration" {
  value {
    id = "${libvirt_domain.domain.0.id}"
    hostname = "${var.base_configuration["name_prefix"]}${var.name}${var.count > 1 ? "-1" : ""}.${var.base_configuration["domain"]}"
  }
}
