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


# ----- Create DNS and Record Set ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/dns_ptrrecord
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


# ----- Create CDN domain ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/cdn_domain

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

# ----- Create WAF domain ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/waf_dedicated_instance

variable az_name {}
variable ecs_flavor_id {}
variable vpc_id {}
variable subnet_id {}
variable security_group_id {}

resource "huaweicloud_waf_dedicated_instance" "instance_1" {
  name               = "instance_1"
  available_zone     = var.az_name
  specification_code = "waf.payperuse.domain"
  ecs_flavor         = var.ecs_flavor_id
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id

  security_group = [
    var.security_group_id
  ]
}