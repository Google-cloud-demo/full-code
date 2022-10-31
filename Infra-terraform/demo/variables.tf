variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "registry_config" {
}

variable "environment_prefix" {

}

variable "iam_policy" {
  default = {
    admin     = []
    reader    = []
    repoAdmin = []
    writer    = []
  }
}

variable "id" {
  type        = string
  description = <<EOD
The secret identifier to create; this value must be unique within the project.
EOD
}

variable "secret" {
  type        = string
  description = <<EOD
  sensitive   = true
The secret payload to store in Secret Manager.
EOD
}
