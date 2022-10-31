# Terraform GKE & Network Module

This module makes it easy to set up a new GKE & VPC Network in GCP by defining your network and subnet ranges 

It supports creating:

- A Google Virtual Private Network (VPC)
- Subnets within the VPC
- Secondary ranges for the subnets (if applicable)
- Cloud router
- cloud nat
- GCP service account
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster

