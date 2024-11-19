provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "VPC-${var.enviroment_name}"
  region = "eu-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = var.tags_to_be_applied
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  #database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  #elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 12)]
  #redshift_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 16)]
  #intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 20)]

  #private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  # public_subnet_names omitted to show default name generation for all three subnets
  #database_subnet_names    = ["DB Subnet One"]
  #elasticache_subnet_names = ["Elasticache Subnet One", "Elasticache Subnet Two"]
  #redshift_subnet_names    = ["Redshift Subnet One", "Redshift Subnet Two", "Redshift Subnet Three"]
  #intra_subnet_names       = []

  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  customer_gateways = {
    IP1 = {
      bgp_asn     = 65112
      ip_address  = "1.2.3.4"
      device_name = "some_name"
    },
    IP2 = {
      bgp_asn    = 65112
      ip_address = "5.6.7.8"
    }
  }

  enable_vpn_gateway = false

  enable_dhcp_options              = false
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["eu-west-2.compute.internal", "AmazonProvidedDNS"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  private_dedicated_network_acl = true

  private_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  private_inbound_acl_rules = [
    {
      rule_number = 1
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.0.0.0/16"
    },
    {
      rule_number = 2
      rule_action = "deny"
      from_port   = 22
      to_port     = 22
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 3
      rule_action = "deny"
      from_port   = 3389
      to_port     = 3389
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 4
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
  ]


  public_dedicated_network_acl = true

  public_inbound_acl_rules = [
    {
      rule_number = 1
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.0.0.0/16"
    },
    {
      rule_number = 2
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 3
      rule_action = "deny"
      from_port   = 3389
      to_port     = 3389
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 4
      rule_action = "deny"
      from_port   = 3306
      to_port     = 3306
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 5
      rule_action = "deny"
      from_port   = 3700
      to_port     = 3700
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 6
      rule_action = "deny"
      from_port   = 46327
      to_port     = 46327
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 7
      rule_action = "deny"
      from_port   = 4848
      to_port     = 4848
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 8
      rule_action = "deny"
      from_port   = 5701
      to_port     = 5701
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 9
      rule_action = "deny"
      from_port   = 7676
      to_port     = 7676
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 10
      rule_action = "deny"
      from_port   = 8686
      to_port     = 8686
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 11
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 12
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    },
        {
      rule_number = 13
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "6"
      cidr_block  = "0.0.0.0/0"
    }
  ]
  tags = local.tags
}

################################################################################
# VPC Endpoints Module
################################################################################

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${local.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service             = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "dynamodb-vpc-endpoint" }
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs_telemetry = {
      create              = false
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    rds = {
      service             = "rds"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.rds_mysql.id]
    },
  }

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })
}

module "vpc_endpoints_nocreate" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["dynamodb:*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpc"

      values = [module.vpc.vpc_id]
    }
  }
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.vpc.vpc_id]
    }
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${local.name}-rds"
  description = "Allow Mysql inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = local.tags
}

resource "aws_security_group" "rds_mysql" {
  name_prefix = "${local.name}-rds"
  description = "Allow Mysql inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = local.tags
}