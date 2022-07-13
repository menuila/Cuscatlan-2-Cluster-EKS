data "aws_security_group" "gitlab" {
  id = var.security_group_id
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "gitlab-instance"

  ami                    = "ami-0414b2c9f70ec8a96"
  instance_type          = "t2.micro"
  key_name               = "root"
  monitoring             = true
  vpc_security_group_ids = data.aws_security_group.gitlab
  subnet_id              = module.vpc.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "Repository"
  }
}
