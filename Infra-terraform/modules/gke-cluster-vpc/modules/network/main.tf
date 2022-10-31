locals {
  ## the following locals modify resource creation behavior depending on var.nat_ip_allocate_option
  cloud_nat_address_count = var.nat_ip_allocate_option == "AUTO_ONLY" ? 0 : var.cloud_nat_address_count
  nat_ips                 = var.nat_ip_allocate_option == "AUTO_ONLY" ? null : google_compute_address.ip_address.*.self_link
}


#######################
# Create the network and subnetworks, including secondary IP ranges on subnetworks
#######################

resource "google_compute_network" "network" {
  name                    = var.network_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

/* note that for secondary ranges necessary for GKE Alias IPs, the ranges have
 to be manually specified with terraform currently -- no GKE automagic allowed here. */
resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnetwork_name
  ip_cidr_range            = var.subnetwork_range
  network                  = google_compute_network.network.self_link
  region                   = var.region
  private_ip_google_access = true
#  enable_flow_logs         = false

  secondary_ip_range {
    range_name    = "gke-pods-1"
    ip_cidr_range = var.subnetwork_pods
  }

  secondary_ip_range {
    range_name    = "gke-services-1"
    ip_cidr_range = var.subnetwork_services
  }

  /* We ignore changes on secondary_ip_range because terraform doesn't list
    them in the same order every time during runs. */
  lifecycle {
    ignore_changes = [secondary_ip_range]
  }
}

resource "google_compute_router" "router" {
  name    = var.network_name
  network = google_compute_network.network.name
  region  = var.region
}

resource "google_compute_address" "ip_address" {
  count  = local.cloud_nat_address_count
  name   = "nat-external-address-${count.index}"
  region = var.region
}

resource "google_compute_router_nat" "nat_router" {
  name                               = var.network_name
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = local.nat_ips
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
