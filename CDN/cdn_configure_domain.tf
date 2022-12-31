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

# ----- Configure CDN domain ----- 
resource "huaweicloud_cdn_domain" "domain_1" {
  name = var.domain_name
  type = "web"
  service_area = "outside_mainland_china"

  sources {
    origin      = var.origin_server
    origin_type = "ipaddr"
    active      = 1
  }

  cache_settings {
    rules {
      rule_type = 0
      ttl       = 180
      ttl_type  = 4
      priority  = 2
    }
  }
}