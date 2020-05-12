resource "aws_route53_record" "swarm-dev-dns" {
  zone_id = "ZP1OTN7RFU1XT"
  name    = "${terraform.workspace}-swarm-dev.sbmdev.net"
  type    = "A"
  alias {
    name                   = aws_lb.swarm-lb.dns_name
    zone_id                = aws_lb.swarm-lb.zone_id
    evaluate_target_health = true
  }
}