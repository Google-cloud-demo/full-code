provider "google" {
  
  project = "boeing-363311"
  //add credentials file  for outside execution
  #credentials = file(var.credentials_file_path)
}

// Backend configuration
 terraform {
   backend "gcs" {
     bucket      = "<bucket-name of state file>"
     prefix      = "terraform/state"
 
   }
 }
module "network" {
  source = "../modules/network"
  // base network parameters
  network_name               = "iot-core"
  subnetwork_name            = "iot-core-private-subnet"
  region                     = "asia-east1"
  enable_flow_logs           = "false"

  //specify the staging subnetwork primary and secondary CIDRs for IP aliasing
  subnetwork_range     = "10.128.0.0/20"
  subnetwork_pods      = "10.128.64.0/18"
  subnetwork_services  = "10.128.32.0/20"

  // Optional Variables
  // AUTO_ONLY or MANUAL_ONLY NAT allocation
  nat_ip_allocate_option = "AUTO_ONLY"
  #nat_ip_allocate_option = "MANUAL_ONLY"
  #cloud_nat_address_count = 2
}

module "cluster" {
  source                           = "../modules/gke-cluster"
  region                           = "asia-east1"
  name                             = "iot-core"
  project                          = "boeing-363311"
  network_name                     = "iot-core"
  nodes_subnetwork_name            = module.network.subnetwork
  kubernetes_version               = "1.22.12-gke.2300"
  pods_secondary_ip_range_name     = module.network.gke_pods_1
  services_secondary_ip_range_name = module.network.gke_services_1
  // private cluster options
  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "10.128.254.0/28"

  master_authorized_network_cidrs = [
    {
//This is the module default, but demonstrates specifying this input.
      cidr_block   = "0.0.0.0/0"
      display_name = "from the Internet"

    },

  ]

}

module "node_pool" {
  source             = "../modules/nodepool"
  name               = "iot-core-nodepool"
  region             = module.cluster.region
  gke_cluster_name   = module.cluster.name
  machine_type       = "e2-small"
  min_node_count     = "1"
  max_node_count     = "2"
  kubernetes_version = module.cluster.kubernetes_version
}

module "gke_service_account" {

  source = "../modules/gke-service-account"

  name        = "iot-core-gsa"
  project     = "boeing-363311"
  description = " "
}

module "artifact-registry" {
  source = "../modules/artifact_registry"

  project_id         = var.project_id
  region             = var.region
  environment_prefix = var.environment_prefix
  registry_config    = var.registry_config
}

module "secret" {
  source     = "../modules/secret-manager"
  version    = "2.0.1"
  project_id = "boeing-363311"
  id         = var.id
  secret     = var.secret
}