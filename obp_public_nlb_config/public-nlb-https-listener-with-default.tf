resource "aws_lb_target_group" "private_alb_target_group_http" {
  name        = "private-alb-target-group-http"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    path     = "/mmb-beta"
    protocol = "HTTP"
  }

}

resource "aws_lb_target_group" "private_alb_target_group_https" {
  name        = "private-alb-target-group-https"
  target_type = "alb"
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    path     = "/mmb-beta"
    protocol = "HTTP"
    port     = 80
  }

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = var.public_nlb_arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.private_alb_target_group_https.arn
  }

  depends_on = [
    var.public_nlb_arn
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.public_nlb_arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.private_alb_target_group_http.arn
  }

  depends_on = [
    var.public_nlb_arn
  ]
}

resource "aws_lb_target_group_attachment" "private_alb_target_group_https_attachment" {
  target_id        = var.private_alb_arn
  target_group_arn = aws_lb_target_group.private_alb_target_group_https.arn
}

resource "aws_lb_target_group_attachment" "private_alb_target_group_http_attachment" {
  target_id        = var.private_alb_arn
  target_group_arn = aws_lb_target_group.private_alb_target_group_http.arn
}
