#!/bin/bash

# Create VPC
vpc_id=$(aws ec2 create-vpc --cidr-block 192.168.0.0/16 --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $vpc_id --tags Key=Name,Value=consoleVPC
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-hostnames "{\"Value\":true}"

# Public Subnet
public_subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 192.168.1.0/24 --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $public_subnet_id --tags Key=Name,Value=ConsolePublicSubnet
aws ec2 modify-subnet-attribute --subnet-id $public_subnet_id --map-public-ip-on-launch

# Private Subnet
private_subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 192.168.2.0/24 --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $private_subnet_id --tags Key=Name,Value=ConsolePrivateSubnet

# Internet Gateway
igw_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 create-tags --resources $igw_id --tags Key=Name,Value=ConsoleIGW
aws ec2 attach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id

# Public Route Table
public_route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $public_route_table_id --tags Key=Name,Value=ConsolePublicRouteTable
aws ec2 create-route --route-table-id $public_route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id
aws ec2 associate-route-table --subnet-id $public_subnet_id --route-table-id $public_route_table_id

# Private Route Table
private_route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $private_route_table_id --tags Key=Name,Value=ConsolePrivateRouteTable
aws ec2 associate-route-table --subnet-id $private_subnet_id --route-table-id $private_route_table_id

# NAT Gateway
eip_allocation_id=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
nat_gateway_id=$(aws ec2 create-nat-gateway --subnet-id $private_subnet_id --allocation-id $eip_allocation_id --query 'NatGateway.NatGatewayId' --output text)
aws ec2 create-route --route-table-id $private_route_table_id --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $nat_gateway_id

# Security Group for Private
private_sg_id=$(aws ec2 create-security-group --group-name ConsolePrivateSG --description "Security Group for Private Subnet" --vpc-id $vpc_id --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $private_sg_id --protocol all --source-group $private_sg_id
aws ec2 authorize-security-group-egress --group-id $private_sg_id --protocol all --cidr 0.0.0.0/0

# Security Group for Public (Allow 443 port)
public_sg_id=$(aws ec2 create-security-group --group-name PublicSG443 --description "Security Group for Public Subnet" --vpc-id $vpc_id --query 'GroupId' --output text)
aws ec2 authorize-security-group-egress --group-id $public_sg_id --protocol tcp --port 443 --cidr 0.0.0.0/0
