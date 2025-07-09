#!/bin/bash
yum update -y
yum install -y httpd aws-cli
systemctl start httpd
systemctl enable httpd
cd /var/www/html
aws s3 cp s3://my-static-site-dinesh-primary/ . --recursive
