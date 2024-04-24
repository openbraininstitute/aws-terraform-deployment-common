resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
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

  tags = {
    SBO_Billing = "common"
  }

  depends_on = [
    aws_lb.alb
  ]
}
