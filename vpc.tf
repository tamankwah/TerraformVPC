# Theo VPC for his terraform
resource "aws_vpc" "Theo-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Theo-VPC"
  }
}
#creating two public subnets
# Public subnets 1 
resource "aws_subnet" "Prod-pub-sub-1" {
  vpc_id     = aws_vpc.Theo-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub-1"
  }
}

# Public subnets 2 
resource "aws_subnet" "Prod-pub-sub-2" {
  vpc_id     = aws_vpc.Theo-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-pub-sub-2"
  }
}
#Creating two private subnets
# Private subnets-1 
resource "aws_subnet" "Prod-pri-sub-1" {
  vpc_id     = aws_vpc.Theo-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-pri-sub-1"
  }
}

# Private subnets-2
resource "aws_subnet" "prod-pri-sub-2" {
  vpc_id     = aws_vpc.Theo-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-pri-sub-2"
  }
}
#creating one public route table
#route table public
resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.Theo-VPC.id
  tags   = {
    Name = "prod-pub-route-table"
  }
}
#creating one private route table
# route table private
resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.Theo-VPC.id
  tags   = {
    Name = "prod-priv-route-table"
  }
}

# public sub association
resource "aws_route_table_association" "prod-public-route-assocaition-1" {
  subnet_id      = aws_subnet.Prod-pub-sub-1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

#  public sub association
resource "aws_route_table_association" "prod-public-route-assocaition-2" {
  subnet_id      = aws_subnet.Prod-pub-sub-2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


#  private sub association
resource "aws_route_table_association" "prod-private-route-assocaition-1" {
  subnet_id      = aws_subnet.Prod-pri-sub-1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

#  private sub association
resource "aws_route_table_association" "prod-private-route-assocaition-2" {
  subnet_id      = aws_subnet.prod-pri-sub-2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

# internet gateway 
resource "aws_internet_gateway" "prod-IGW" {
  vpc_id = aws_vpc.Theo-VPC.id

  tags = {
    Name = "prod-IGW"
  }
}

#  IGW Association to route
resource "aws_route" "prod-IGW-association-route" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.prod-IGW.id
  destination_cidr_block    = "0.0.0.0/0"
}
#creating elastic ip adress
resource "aws_eip" "NAT_eip" {

  tags = {
    Name = "NAT_eip"
  }
}

#creating NAT gateway
resource "aws_nat_gateway" "prod-Nat-gateway" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = aws_subnet.Prod-pub-sub-1.id

  tags = {
    Name = "prod-NAT-gateway"
  }
}

#routing the NAT gateway
resource "aws_route" "prod-NAT-association-route" {
  route_table_id            = aws_route_table.prod-priv-route-table.id
  gateway_id                = aws_nat_gateway.prod-Nat-gateway.id
  destination_cidr_block    = "0.0.0.0/0"
}