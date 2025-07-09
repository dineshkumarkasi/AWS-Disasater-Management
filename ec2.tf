# IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AmazonS3ReadOnlyAccess policy to IAM Role
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Instance Profile for EC2 to use the IAM role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_s3_access.name
}

# Security Group for EC2 (Primary)
resource "aws_security_group" "web_sg_primary" {
  provider = aws.primary
  name     = "web-sg-primary"
  vpc_id   = aws_vpc.primary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg-primary"
  }
}

# Security Group for EC2 (Secondary)
resource "aws_security_group" "web_sg_secondary" {
  provider = aws.secondary
  name     = "web-sg-secondary"
  vpc_id   = aws_vpc.secondary.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg-secondary"
  }
}

# EC2 Instance in Primary Region
resource "aws_instance" "web-primary" {
  provider                    = aws.primary
  ami                         = "ami-05ffe3c48a9991133" # Amazon Linux 2 for us-east-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_primary.id
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.web_sg_primary.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = file("ec2/user_data.sh")

  tags = {
    Name = "web-primary"
  }
}

# EC2 Instance in Secondary Region
resource "aws_instance" "web-secondary" {
  provider                    = aws.secondary
  ami                         = "ami-061ad72bc140532fd" # Amazon Linux 2 for us-west-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_secondary.id
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.web_sg_secondary.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = file("ec2/user_data_secondary.sh")

  tags = {
    Name = "web-secondary"
  }
}
