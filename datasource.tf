data "aws_ami" "latest_windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

output "latest_windows_ami_id" {
  value = data.aws_ami.latest_windows.id
}