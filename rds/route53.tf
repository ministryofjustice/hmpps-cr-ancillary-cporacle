###############################################
# Create route53 entry for rds
###############################################

# resource "aws_route53_record" "rds_dns_entry" {
#   name    = "${local.dns_name}.${local.internal_domain}"
#   type    = "CNAME"
#   zone_id = local.private_zone_id
#   ttl     = 300
#   records = [module.db_instance.db_instance_address]
# }