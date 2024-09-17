resource "aws_lb_listener" "http" {
  load_balancer_arn = var.private_alb_arn
  port              = 80
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    var.private_alb_arn
  ]
}
