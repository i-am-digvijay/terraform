resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment}-deployer-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet_id

  tags = {
    Name = "${var.environment}-server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip

 }

   provisioner "file" {
    source      = var.app_script_path
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Starting application setup for ${var.environment} environment'",
      "sudo apt-get update -y",
      "sudo apt-get install -y python3-pip python3-venv python3-full",
      "cd /home/ubuntu",
      "python3 -m venv venv",
      "./venv/bin/python -m pip install --upgrade pip setuptools wheel",
      "./venv/bin/python -m pip install flask",
      "sudo nohup ./venv/bin/python app.py > /tmp/app.log 2>&1 &",
      "echo 'Application started successfully'"
    ]
  }
}
