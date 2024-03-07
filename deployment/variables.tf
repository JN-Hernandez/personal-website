variable "account_id" {
  type      = string
  sensitive = true
}

data "github_actions_secret" "AWS_ACCOUNT_ID" {
  secret_name = "AWS_ACCOUNT_ID"
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "owner_name" {
  default = "jn-hernandez"
  type    = string
}

variable "project" {
  default = "personal-website"
  type    = string
}
