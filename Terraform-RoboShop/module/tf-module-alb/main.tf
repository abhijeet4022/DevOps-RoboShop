# Application Load Balancer
resource "aws_lb" "main" {
  name               = local.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets
  tags               = merge(local.tags, { Name = local.alb_name })
}

# Listener Creation
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.internal ? 80 : 443
  protocol          = var.internal ? "HTTP" : "HTTPS"
  ssl_policy        = var.internal ? null : "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.internal ? null : var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ERROR"
      status_code  = "400"
    }
  }
}

# Redirect public LB http request to https.
resource "aws_lb_listener" "frontend" {
  count             = var.internal ? 0 : 1
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# Security Group Creation
resource "aws_security_group" "main" {
  name        = local.sg_name
  description = local.sg_name
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = local.sg_name })
  ingress {
    description = "APP"
    from_port   = var.sg_port
    to_port     = var.sg_port
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Adding port 80 in SG for public alb
resource "aws_security_group_rule" "main" {
  count             = var.internal ? 0 : 1
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.sg_ingress_cidr
  security_group_id = aws_security_group.main.id
}