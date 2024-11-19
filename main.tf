data "aws_availability_zones" "available" {}

locals {
  region = "eu-west-2"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr = "10.0.0.0/16"
}


provider "aws" {
  region = local.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
    vpc_cidr = local.vpc_cidr
  
}


module "DBClusterSecureConnect" {
  source = "./modules/database"
  availability_zones = local.azs
  list_of_subnets = module.vpc.private_subnets
  rds_kms_key_id_arn = "arn:aws:kms:eu-west-2:085214634431:key/fccdbefb-f10c-4c24-bcc8-65cff005c366"
  list_of_SG = tolist([module.sg.EatonSecureConnect-rds-SG-id])
  
}

module "ec2-isntaces" {
  source = "./modules/ec2-instances"
  kms_arn = "arn:aws:kms:eu-west-2:085214634431:key/mrk-a307af6b27ef404d8520554964874553"
  key_name = "Eaton-QA-AcessKeyPair"

    
  ami_to_be_used_for_rabbitmq = "ami-09885f3ec1667cbfc"
  ip_to_be_used_for_rabbitmq = "10.0.0.5"
  az_to_be_used_for_rabbitmq = "eu-west-2a"
  subnet_id_rabbitmq = tolist(module.vpc.private_subnets)[0]
  security_groups_rabbitmq = tolist([module.sg.RabbitMQ-SG-id])

  ami_to_be_used_for_producer_a = "ami-083f5321ceb82d213"
  ip_to_be_used_for_producer_a = "10.0.0.10"
  az_to_be_used_for_producer_a = "eu-west-2a"
  subnet_id_producer_a = tolist(module.vpc.private_subnets)[0]
  security_groups_producer_a = tolist([module.sg.EatonProducers-SG-id])

  ami_to_be_used_for_producer_b = "ami-083f5321ceb82d213"
  ip_to_be_used_for_producer_b = "10.0.1.10"
  az_to_be_used_for_producer_b = "eu-west-2b"
  subnet_id_producer_b = tolist(module.vpc.private_subnets)[1]
  security_groups_producer_b = tolist([module.sg.EatonProducers-SG-id])

  ami_to_be_used_for_consumer_a = "ami-083f5321ceb82d213"
  ip_to_be_used_for_consumer_a = "10.0.0.11"
  az_to_be_used_for_consumer_a = "eu-west-2a"
  subnet_id_consumer_a = tolist(module.vpc.private_subnets)[0]
  security_groups_consumer_a = tolist([module.sg.EatonConsumers-SG-id])

  ami_to_be_used_for_consumer_b = "ami-083f5321ceb82d213"
  ip_to_be_used_for_consumer_b = "10.0.1.11"
  az_to_be_used_for_consumer_b = "eu-west-2b"
  subnet_id_consumer_b = tolist(module.vpc.private_subnets)[1]
  security_groups_consumer_b = tolist([module.sg.EatonConsumers-SG-id])
}