#aws provider configuration
# This file configures the AWS provider for Terraform, specifying the region and profile to use.

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["/Users/mick8/.aws/credentials"]

}

