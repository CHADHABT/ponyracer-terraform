/* Create a VPC */

resource "aws_vpc" "VPC" {
    cidr_block = "${var.VPC_CIDR}"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

resource "aws_internet_gateway" "INTERNET_GATEWAY" {
    vpc_id = "${aws_vpc.VPC.id}"

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

resource "aws_route_table" "ROUTE_TABLE" {
    vpc_id = "${aws_vpc.VPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.INTERNET_GATEWAY.id}"
    }

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

resource "aws_main_route_table_association" "ROUTE_TABLE_ASSOCIATION" {
    vpc_id = "${aws_vpc.VPC.id}"
    route_table_id = "${aws_route_table.ROUTE_TABLE.id}"
}

resource "aws_vpc_dhcp_options" "DNS_RESOLVER" {
    domain_name_servers = ["AmazonProvidedDNS"]

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

resource "aws_vpc_dhcp_options_association" "DHCP_OPTIONS_ASSOCIATION" {
    vpc_id = "${aws_vpc.VPC.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.DNS_RESOLVER.id}"
}

resource "aws_subnet" "PUBLIC_SUBNET" {
    count 				= "${length(var.PUBLIC_SUBNET_CIDRS)}"
    vpc_id 				= "${aws_vpc.VPC.id}"
    cidr_block			= "${var.PUBLIC_SUBNET_CIDRS[count.index]}"
    availability_zone 	= "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

resource "aws_route_table" "SUBNET_ROUTE_TABLE" {
    vpc_id = "${aws_vpc.VPC.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.INTERNET_GATEWAY.id}"
    }
}

resource "aws_route_table_association" "PUBLIC_SUBNETS_ROUTE_TABLE" {
	count 			= "${length(var.PUBLIC_SUBNET_CIDRS)}"
	subnet_id      	= "${element(aws_subnet.PUBLIC_SUBNET.*.id, count.index)}"
	route_table_id 	= "${aws_route_table.SUBNET_ROUTE_TABLE.id}"
}