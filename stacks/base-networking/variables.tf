variable "environment" {
  type        = string
  description = "Uniquely idenities each deployment, i.e. dev, prod."
}

variable "team" {
  type        = string
  default     = "Registrations"
  description = "Team owning this resource"
}

variable "repo_name" {
  type        = string
  default     = "prm-gp2gp-data-pipeline-infra"
  description = "Name of this repository"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block to assign VPC"
  default     = "10.55.0.0/16"
}