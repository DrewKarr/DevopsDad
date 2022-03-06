variable "region" {
  type    = string
  default = "us-east1"
}

variable "project_id" {
  type    = string
  default = "drewlearns-gke"
}

variable "cluster_name" {
  type    = string
  default = "drewlearns-cluster"
}

variable "k8s_version" {
  type = string
  default = "1.22.6-gke.1000"
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "preemptible" {
  type    = bool
  default = true
}

variable "state_bucket" {
  type    = string
  default = state
}
