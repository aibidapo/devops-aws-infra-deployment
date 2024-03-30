data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "ai_devops_prod_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}


resource "aws_instance" "ai_devops_prod_main" {

  count = var.main_instance_count

  instance_type = var.main_instance_type
  ami           = data.aws_ami.server_ami.id
  key_name = aws_key_pair.ai_devops_prod_auth.id
  vpc_security_group_ids = [aws_security_group.ai_devops_prod_sg.id]
  subnet_id              = aws_subnet.ai_devops_prod_public_subnet[count.index].id
  user_data = templatefile("./main-userdata.tpl", {new_hostname = "${local.account_name}-main-${random_id.ai_devops_prod_node_id[count.index].dec}"})
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "${local.account_name}-main-${random_id.ai_devops_prod_node_id[count.index].dec}"
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts"
  }

}

resource "aws_key_pair" "ai_devops_prod_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

