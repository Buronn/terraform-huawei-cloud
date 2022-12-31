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

# ----- Create DNS and Record Set ----- https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/dns_ptrrecord
resource "huaweicloud_dns_zone" "example_zone" {
  name        = var.domain_name
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
  records     = [var.origin_server]
}