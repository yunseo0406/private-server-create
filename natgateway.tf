# NAT Gateway Subnet 생성
resource "ncloud_subnet" "nat_gw_subnet" {
  vpc_no         = ncloud_vpc.yunseo_vpc.id
  name           = "nat-gw-subnet"
  subnet         = "10.0.1.0/24"
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.yunseo_vpc.default_network_acl_no
  subnet_type    = "PUBLIC" // PUBLIC(Public) | PRIVATE(Private)
  usage_type     = "NATGW"
}

# NAT Gateway 생성
resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no      = ncloud_vpc.yunseo_vpc.id
  subnet_no   = ncloud_subnet.nat_gw_subnet.id
  zone        = "KR-2"
  // below fields are optional
  name        = "nat-gw"
}

# Private용 라우트 테이블 (규칙은 아직 없음)
resource "ncloud_route_table" "route_table" {
  vpc_no                = ncloud_vpc.yunseo_vpc.id
  name                  = "route-table-private"
  supported_subnet_type = "PRIVATE"
}

resource "ncloud_route" "route_rule" {
  route_table_no         = ncloud_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW"  // NATGW (NAT Gateway) | VPCPEERING (VPC Peering) | VGW (Virtual Private Gateway).
  target_name            = ncloud_nat_gateway.nat_gateway.name
  target_no              = ncloud_nat_gateway.nat_gateway.id
}

# Private Subnet에 라우트 테이블 연결
resource "ncloud_route_table_association" "assoc_private" {
  subnet_no      = ncloud_subnet.private_subnet.id
  route_table_no = ncloud_route_table.route_table.id
}

