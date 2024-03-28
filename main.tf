module "domains" {
  source = "./domains"


  primary_domain_name   = "openbluebrain.ch"
  secondary_domain_name = "openbluebrain.com"
  public_abl_dns_name   = aws_lb.alb.dns_name
  public_abl_zone_id    = aws_lb.alb.zone_id

}
