terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.26.0"
    }
  }
}

# Configure the HuaweiCloud Provider
provider "huaweicloud" {}

variable "domain_name" {
  default = "tf.buron.social"
}
variable "origin_server" {
  default = "159.138.115.199"
}

# ----- Create WAF domain ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/waf_dedicated_instance

