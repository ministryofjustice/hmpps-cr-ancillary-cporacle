resource "aws_route53_record" "cporacle_api" {
  zone_id = local.strategic_public_zone_id
  name    = "cporacle-api"
  type    = "A"

  alias {
    name                   = aws_alb.alb_api.dns_name
    zone_id                = aws_alb.alb_api.zone_id
    evaluate_target_health = true
  }
}
