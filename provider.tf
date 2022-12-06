terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
       version = "~> 4.0"
      configuration_aliases = [ aws.source, aws.central ]
    }
  }
  required_version = ">= 0.14.9"
}
provider "aws" {
  alias   = "source"
  region  = "eu-west-1"
  version = "v2.70.0"
  profile = "PrachiAWS"
}

provider "aws" {
  alias   = "central"
  region  = "eu-central-1"
  version = "v2.70.0"
  profile = "PrachiAWS"
}
