provider "aws" {
  region = var.aws_region
}

# Data block to fetch existing security group by name (if it exists)
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["strapi-appvcv-seecg"]
  }
}

# Create security group only if it doesn't exist (optional workaround)
resource "aws_security_group" "strapi_sg" {
  count       = length(data.aws_security_group.existing_sg.ids) == 0 ? 1 : 0
  name        = "strapi-appvcv-seecg"
  description = "Allow SSH and Strapi ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Pick the security group: existing one or newly created one
locals {
  strapi_sg_id = length(data.aws_security_group.existing_sg.ids) > 0 ? data.aws_security_group.existing_sg.id : aws_security_group.strapi_sg[0].id
}

resource "aws_instance" "strapi" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [local.strapi_sg_id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker

    docker network create strapi-net

    docker run -d --name postgres --network strapi-net \
      -e POSTGRES_DB=strapi \
      -e POSTGRES_USER=strapi \
      -e POSTGRES_PASSWORD=strapi \
      -v /srv/pgdata:/var/lib/postgresql/data \
      postgres:15

    docker pull varunchavda78/strapi-app:${var.image_tag}

    docker run -d --name strapi --network strapi-net \
      -e DATABASE_CLIENT=postgres \
      -e DATABASE_HOST=postgres \
      -e DATABASE_PORT=5432 \
      -e DATABASE_NAME=strapi \
      -e DATABASE_USERNAME=strapi \
      -e DATABASE_PASSWORD=strapi \
      -e APP_KEYS=cd446k4vsItBPRI8hPr2bw==,dnXv48JDVT7LptYAFRHTaA==,8GggVZTb36gRw/88mHmWow==,h6G1JRVl104ltXtvvHpvtA== \
      -e API_TOKEN_SALT=OX3tBEnxGN9/uCw/1Jqz0Q== \
      -e ADMIN_JWT_SECRET=6uoLuxGM+1TXcQKjCG4Rrg== \
      -p 1337:1337 \
      varunchavda78/strapi-app:${var.image_tag}
  EOF

  tags = {
    Name = "strapi-varunn"
  }

  lifecycle {
    prevent_destroy = true
  }
}
