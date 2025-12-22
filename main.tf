provider "google" {
  project = var.project_id
}

resource "google_compute_firewall" "allow-traffic" {
  name    = "${var.goog_cm_deployment_name}-allow-ports"
  network = local.create_vpc ? google_compute_network.vpc[0].name : data.google_compute_network.existing_vpc[0].name

  allow {
    protocol = "tcp"
    ports    = ["443", "943"]
  }

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = var.inbound_source_ranges

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

locals {
  export_env_vars = join(
    "\n",
    [
      for k, v in var.env_vars :
      "export ${k}=${jsonencode(v)}"
      if v != null && v != ""
    ]
  )
}

resource "google_compute_instance" "instance" {
  name         = "${var.goog_cm_deployment_name}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["${var.goog_cm_deployment_name}-deployment"]

  boot_disk {
    device_name = "${var.goog_cm_deployment_name}-disk"

    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.source_image
    }
  }

  network_interface {
    subnetwork = local.create_vpc ? google_compute_subnetwork.subnet[0].id : data.google_compute_subnetwork.existing_subnet[0].id

    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash

    # Export Terraform-provided env vars
    ${local.export_env_vars}

    bash -c 'bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --yes --as-version=3.0.2'
  EOF
}

output "vm_public_ip" {
  value = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}
