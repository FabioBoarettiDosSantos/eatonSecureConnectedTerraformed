
resource "aws_iam_role" "InstanceRole-Web" {
  name = "InstanceRole-Web"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "InstanceRole-Web-Profile" {
  name = "InstanceRole-Web-Profile"
  role = "${aws_iam_role.InstanceRole-Web.name}"
}


resource "aws_iam_policy" "InstanceRolePolicy" {
  name        = "InstanceRolePolicy"
  path        = "/"
  description = "InstanceRolePolicy"

  policy = jsonencode({
    "Statement": [
        {
            "Action": "cloudformation:Describe",
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        },
        {
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "ssm:DescribeInstanceInformation",
                "ssm:CreateAssociation",
                "ssm:StartSession",
                "ssm:TerminateSession",
                "ssm:ResumeSession",
                "ssm:DescribeSessions",
                "ssm:GetConnectionStatus"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        },
        {
            "Action": [
                "ssm:GetParameter",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "ec2:DescribeTags",
                "cloudwatch:PutMetricData",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        },
        {
            "Action": "ec2:DescribeTags",
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        }
    ],
    "Version": "2012-10-17"
})
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attachment-InstanceRolePolicy-to-InstanceRole-Web" {
  role       = aws_iam_role.InstanceRole-Web.name
  policy_arn = aws_iam_policy.InstanceRolePolicy.arn
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attachment-AmazonSSMManagedInstanceCore-to-InstanceRole-Web" {
  role       = aws_iam_role.InstanceRole-Web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



resource "aws_instance" "RABBIT_MQ" {
  ami                         = var.ami_to_be_used_for_rabbitmq
  associate_public_ip_address = "false"
  availability_zone           = var.az_to_be_used_for_rabbitmq

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = aws_iam_instance_profile.InstanceRole-Web-Profile.name
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.small"
  ipv6_address_count                   = "0"
  key_name                             = var.key_name

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = var.ip_to_be_used_for_rabbitmq

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            =  var.kms_arn
    volume_size           = "50"
    volume_type           = "gp2"
  }

  source_dest_check = "true"
  subnet_id         = var.subnet_id_rabbitmq

  tags = {
    Name               = "RABBIT_MQ"
  }

  tags_all = {
    Name               = "RABBIT_MQ"
  }

  tenancy                = "default"

  vpc_security_group_ids = var.security_groups_rabbitmq
}


resource "aws_instance" "PRODUCER_A" {
  ami                         = var.ami_to_be_used_for_producer_a
  associate_public_ip_address = "false"
  availability_zone           = var.az_to_be_used_for_producer_a

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = aws_iam_instance_profile.InstanceRole-Web-Profile.name
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.2xlarge"
  ipv6_address_count                   = "0"
  key_name                             = var.key_name

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = var.ip_to_be_used_for_producer_a

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            =  var.kms_arn
    volume_size           = "100"
    volume_type           = "gp3"
    throughput            = "125"
  }

  source_dest_check = "true"
  subnet_id         = var.subnet_id_producer_a

  tags = {
    Name               = "PRODUCER_A"
  }

  tags_all = {
    Name               = "PRODUCER_A"
  }

  tenancy                = "default"

  vpc_security_group_ids = var.security_groups_producer_a
}

resource "aws_instance" "PRODUCER_B" {
  ami                         = var.ami_to_be_used_for_producer_b
  associate_public_ip_address = "false"
  availability_zone           = var.az_to_be_used_for_producer_b

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = aws_iam_instance_profile.InstanceRole-Web-Profile.name
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.2xlarge"
  ipv6_address_count                   = "0"
  key_name                             = var.key_name

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = var.ip_to_be_used_for_producer_b

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            =  var.kms_arn
    volume_size           = "100"
    volume_type           = "gp3"
    throughput            = "125"
  }

  source_dest_check = "true"
  subnet_id         = var.subnet_id_producer_b

  tags = {
    Name               = "PRODUCER_B"
  }

  tags_all = {
    Name               = "PRODUCER_B"
  }

  tenancy                = "default"

  vpc_security_group_ids = var.security_groups_producer_b
}

resource "aws_instance" "CONSUMER_A" {
  ami                         = var.ami_to_be_used_for_consumer_a
  associate_public_ip_address = "false"
  availability_zone           = var.az_to_be_used_for_consumer_a

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = aws_iam_instance_profile.InstanceRole-Web-Profile.name
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.2xlarge"
  ipv6_address_count                   = "0"
  key_name                             = var.key_name

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = var.ip_to_be_used_for_consumer_a

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            =  var.kms_arn
    volume_size           = "100"
    volume_type           = "gp3"
    throughput            = "125"
  }

  source_dest_check = "true"
  subnet_id         = var.subnet_id_consumer_a

  tags = {
    Name               = "CONSUMER_A"
  }

  tags_all = {
    Name               = "CONSUMER_A"
  }

  tenancy                = "default"

  vpc_security_group_ids = var.security_groups_consumer_a
}

resource "aws_instance" "CONSUMER_B" {
  ami                         = var.ami_to_be_used_for_consumer_b
  associate_public_ip_address = "false"
  availability_zone           = var.az_to_be_used_for_consumer_b

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = aws_iam_instance_profile.InstanceRole-Web-Profile.name
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.2xlarge"
  ipv6_address_count                   = "0"
  key_name                             = var.key_name

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = var.ip_to_be_used_for_consumer_b

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            =  var.kms_arn
    volume_size           = "100"
    volume_type           = "gp3"
    throughput            = "125"
  }

  source_dest_check = "true"
  subnet_id         = var.subnet_id_consumer_b

  tags = {
    Name               = "CONSUMER_B"
  }

  tags_all = {
    Name               = "CONSUMER_B"
  }

  tenancy                = "default"

  vpc_security_group_ids = var.security_groups_consumer_b
}