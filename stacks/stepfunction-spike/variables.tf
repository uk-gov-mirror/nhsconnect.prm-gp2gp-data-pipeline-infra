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

variable "region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block to assign VPC"
  default     = "10.55.0.0/16"
}

variable "wordcount_repo_name" {
  type        = string
  description = "Docker repository of wordcount"
  default     = "registrations/data-wordcount-example"
}

variable "wordcount_image_tag" {
  type        = string
  description = "Docker image tag of word count"
  default     = "1"
}

variable "findtoptenwords_repo_name" {
  type        = string
  description = "Docker repository of findtoptenwords"
  default     = "registrations/data-findtoptenwords-example"
}

variable "findtoptenwords_image_tag" {
  type        = string
  description = "Docker image tag of findtoptenwords"
  default     = "1"
}
