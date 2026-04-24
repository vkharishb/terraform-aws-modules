resource "aws_iam_role" "this" {
  count = var.create_iam_role ? 1 : 0

  name = "${var.name}-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids

  user_data = var.user_data

  iam_instance_profile = var.create_iam_role ? aws_iam_instance_profile.this[0].name : null

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    create_before_destroy = true
  }
}

