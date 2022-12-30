terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.26.0"
    }
  }
}

# Configure the HuaweiCloud Provider
provider "huaweicloud" {}


# ----- Create DNS and Record Set -----
resource "huaweicloud_dns_zone" "example_zone" {
  name        = "tf.buron.social"
  email       = "fernando.buron@mail.udp.cl"
  description = "DNS Public Zone created from Terraform"
  ttl         = 6000
  zone_type   = "public"
}

resource "huaweicloud_dns_recordset" "dns_recordset" {
  zone_id     = huaweicloud_dns_zone.example_zone.id
  name        = "tf.buron.social."
  description = "DNS Record from Terraform"
  ttl         = 3000
  type        = "A"
  records     = ["159.138.115.199"]
}


# ----- Create CDN domain -----

variable "domain_name" {}
variable "origin_server" {}

resource "huaweicloud_cdn_domain" "domain_1" {
  name = var.domain_name
  type = "web"

  sources {
    origin      = var.origin_server
    origin_type = "ipaddr"
    active      = 1
  }

  tags = {
    key = "val"
    foo = "bar"
  }
}