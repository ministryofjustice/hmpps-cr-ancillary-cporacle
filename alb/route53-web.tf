resource "aws_route53_record" "cporacle" {
  zone_id = local.strategic_public_zone_id
  name    = "cporacle"
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}