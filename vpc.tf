resource "aws_vpc" "batch_vpc" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

# resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
#   vpc_id = aws_vpc.batch_vpc.id
#   service_name = "com.amazonaws.${var.aws_region}.logs"
#   vpc_endpoint_type = "Interface"
#   subnet_ids = [aws_subnet.bucket_vpc_subnet.*.id ]
# }

resource "aws_subnet" "bucket_vpc_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.batch_vpc.id
  map_public_ip_on_launch = true
  cidr_block        = element(var.subnet_cidr_blocks, count.index)
  availability_zone = element(var.subnet_availability_zones, count.index)
  tags              = var.tags
}

locals {
  ingress = [

    ]
  egress  = [
    {
        description = "for all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
    }
   ]  
}

resource "aws_security_group" "batch_vpc_sg" {
  name        = var.sg_name
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.batch_vpc.id
  ingress     = local.ingress
  egress      = local.egress

  tags        = var.tags 
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.batch_vpc.id
  tags = var.tags
}

resource "aws_route_table" "batch_route_table" {
  vpc_id = aws_vpc.batch_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "batch_route_table_association" {
  count = var.subnet_count
  subnet_id = aws_subnet.bucket_vpc_subnet[count.index].id 
  route_table_id = aws_route_table.batch_route_table.id
}