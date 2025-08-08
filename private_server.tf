resource "ncloud_server" "private_server" {
  subnet_no                 = ncloud_subnet.private_subnet.id
  name                      = "private-server"
  server_image_number       = "23214590" # ubuntu 22.04-base
  server_spec_code          = "s2-g3"
  login_key_name            = "yunseo-key" # 기존에 만든 키 이름
}