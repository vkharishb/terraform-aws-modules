#!/bin/bash
yum update -y
yum install -y amazon-cloudwatch-agent

echo "Linux instance ready" > /home/ec2-user/status.txt