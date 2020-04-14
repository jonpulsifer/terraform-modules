resource "google_compute_network" "network" {
  name                    = var.name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnet" {
  provider                 = google-beta
  name                     = var.subnet_name
  ip_cidr_range            = var.ip_cidr_range
  network                  = google_compute_network.network.self_link
  private_ip_google_access = var.private_api_access

  dynamic "log_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

output "network" {
  value = {
    "name"      = google_compute_network.network.name
    "self_link" = google_compute_network.network.self_link
  }
}
output "subnet" {
  value = {
    "name"      = google_compute_subnetwork.subnet.name
    "self_link" = google_compute_subnetwork.subnet.self_link
  }
}
