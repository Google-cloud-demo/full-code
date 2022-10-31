output "network_self_link" {
  value = google_compute_network.network.self_link
}

output "subnetwork" {
  value = google_compute_subnetwork.subnetwork.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.subnetwork.self_link
}

output "router_self_link" {
  value = google_compute_router.router.self_link
}

output "subnetwork_pods" {
  value = var.subnetwork_pods
}

output "subnetwork_range" {
  value = var.subnetwork_range
}

/* provide the literal names of the secondary IP ranges for the pods and services.
GKE terraform config needs the names as an input. */
output "gke_pods_1" {
  value = "gke-pods-1"
}

output "gke_services_1" {
  value = "gke-services-1"
}

