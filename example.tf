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
  default = "tf.fburon.cl"
}
variable "origin_server" {
  default = "159.138.115.199"
}

# ----- Create DNS ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/dns_ptrrecord
resource "huaweicloud_dns_zone" "example_zone" {
  name        = var.domain_name
  email       = "contacto.buron@gmail.com"
  description = "DNS Public Zone created from Terraform"
  ttl         = 6000
  zone_type   = "public"
}


# ----- Create CDN domain ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/cdn_domain


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

# ----- Add record set to DNS ----- 
resource "huaweicloud_dns_recordset" "cdn_recordset" {
  zone_id     = huaweicloud_dns_zone.example_zone.id
  name        = var.domain_name
  description = "DNS Record from Terraform"
  ttl         = 3000
  type        = "CNAME"
  records     = [huaweicloud_cdn_domain.domain_1.cname]
}

# ----- Create WAF domain ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/waf_dedicated_instance

resource "huaweicloud_waf_domain" "domain_1" {
  domain           = "www.example.com"
  proxy            = true

  server {
    client_protocol = "HTTP"
    server_protocol = "HTTP"
    address         = var.origin_server
    port            = 8080
  }
}