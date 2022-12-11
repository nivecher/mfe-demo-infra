provider "aws" {
  region = "us-east-2"
}

/* data "aws_region" "current" {} */

locals {
  site_domain = "demo.microfrontends.com"
}

resource "aws_route53_zone" "hosted_zone" {
  name = "microfrontends.com"
}

/* data "aws_route53_zone" "hosted_zone" {
  name = "microfrontends.com"
} */
