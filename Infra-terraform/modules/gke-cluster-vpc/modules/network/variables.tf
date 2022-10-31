#######################
# Define all the variables we'll need
#######################

variable "network_name" {
  description = "the name of the network"
}

variable "subnetwork_name" {
  description = "name for the subnetwork"
}

variable "subnetwork_range" {
  description = "CIDR for subnetwork nodes"
}

variable "subnetwork_pods" {
  description = "secondary CIDR for pods"
}

variable "subnetwork_services" {
  description = "secondary CIDR for services"
}

variable "region" {
  description = "region to use"
}

variable "enable_flow_logs" {
  description = "whether to turn on flow logs or not"
}

variable "nat_ip_allocate_option" {
  # https://cloud.google.com/nat/docs/overview#ip_address_allocation
  description = "AUTO_ONLY or MANUAL_ONLY"
  default     = "AUTO_ONLY"
}

variable "cloud_nat_address_count" {
  # https://cloud.google.com/nat/docs/overview#number_of_nat_ports_and_connections
  description = "the count of external ip address to assign to the cloud-nat object"
  default     = 1
}

