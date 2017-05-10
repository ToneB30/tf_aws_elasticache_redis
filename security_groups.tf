resource "aws_security_group" "redis_security_group" {
  name        = "tf-sg-ec-${var.name}-${data.aws_vpc.vpc.tags["Name"]}"
  description = "Terraform-managed ElastiCache security group for ${var.name}-${data.aws_vpc.vpc.tags["Name"]}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags {
    Name = "tf-sg-ec-${var.name}-${data.aws_vpc.vpc.tags["Name"]}"
  }
}

resource "aws_security_group_rule" "redis_ingress" {
  count                    = "${length(var.allowed_security_groups)}"
  type                     = "ingress"
  from_port                = "${var.redis_port}"
  to_port                  = "${var.redis_port}"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_security_groups, count.index)}"
  security_group_id        = "${aws_security_group.redis_security_group.id}"
}

resource "aws_security_group_rule" "redis_networks_ingress" {
  type                     = "ingress"
  from_port                = "${var.redis_port}"
  to_port                  = "${var.redis_port}"
  protocol                 = "tcp"
  cidr_blocks              = "${var.allowed_cidr}"
  security_group_id        = "${aws_security_group.redis_security_group.id}"
}
