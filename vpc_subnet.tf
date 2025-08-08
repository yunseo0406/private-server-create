# VPC 생성
resource "ncloud_vpc" "yunseo_vpc" {
  name             = "yunseo-vpc"
  ipv4_cidr_block  = "10.0.0.0/16"
}

# Subnet 생성
resource "ncloud_subnet" "private_subnet" {
  name             = "private-subnet"
  vpc_no           = ncloud_vpc.yunseo_vpc.id
  subnet           = "10.0.1.0/24"
  zone             = "KR-2"
  subnet_type      = "PRIVATE"
  usage_type       = "GEN"
  network_acl_no   = ncloud_vpc.yunseo_vpc.default_network_acl_no
}

# ACG 생성
resource "ncloud_access_control_group" "acg" {
    name = "private-acg"
    vpc_no = ncloud_vpc.yunseo_vpc.id
}
 # ACG 규칙 생성
resource "ncloud_access_control_group_rule" "acg_rule" {
  access_control_group_no = ncloud_access_control_group.acg.id
  
  inbound {
    protocol = "TCP"
    ip_block = "0.0.0.0/0"
    port_range = "80"
  }

  inbound {
    protocol    = "ICMP"
    ip_block    = "0.0.0.0/0"
  }

  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
  }
}