# -------------------------------
# EC2 Security Group (Needed for RDS SG reference)
# -------------------------------
resource "aws_security_group" "ec2_sg" {
  provider = aws.primary
  name     = "ec2-sg"
  vpc_id   = aws_vpc.primary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 SG Primary"
  }
}

# -------------------------------
# Security Group for RDS (Allows inbound MySQL from EC2 SG)
# -------------------------------
resource "aws_security_group" "rds_sg_primary" {
  provider = aws.primary
  name     = "rds-sg-primary"
  vpc_id   = aws_vpc.primary.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS SG Primary"
  }
}

# -------------------------------
# Subnet Group for RDS
# -------------------------------
resource "aws_db_subnet_group" "rds_subnet_group_primary" {
  provider   = aws.primary
  name       = "rds-subnet-group-primary"
subnet_ids = [
  aws_subnet.private_subnet1.id,
  aws_subnet.private_subnet2.id
]

  tags = {
    Name = "RDS Subnet Group Primary"
  }
}

# -------------------------------
# RDS Primary Instance
# -------------------------------
resource "aws_db_instance" "primary_rds" {
  provider            = aws.primary
  identifier          = "primary-db"
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = var.db_username
  password            = var.db_password
  db_name             = "appdb"
  publicly_accessible = false
  multi_az            = false
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg_primary.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group_primary.name

  tags = {
    Name = "Primary RDS DB"
  }
}
