locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "web" {
  #access_key    = "${var.aws_eaccess_key}"
  ami_name      = "packer-web-${local.timestamp}"
  instance_type = "t3.micro"
  region        = "ap-northeast-1"
  #secret_key    = "${var.aws_secret_key}"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user" 

  tags = {
    Name = "packer-web-${local.timestamp}"
  }
}

build {
  sources = ["source.amazon-ebs.web"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_CONFIG=./ansible-samples/ansible.cfg"]
    playbook_file = "./ansible-samples/playbooks/web.yml"
    groups = ["web"]
  }
}
