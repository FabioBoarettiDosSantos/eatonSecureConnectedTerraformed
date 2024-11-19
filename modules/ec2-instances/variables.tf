variable "vpc_id" {
  description = "Vpc Id"
  type        = string
  default     = ""
}

variable "kms_arn" {
  description = "kms_arn"
  type        = string
  default     = ""
}

#########
#RABBITMQ
#########
variable "ami_to_be_used_for_rabbitmq" {
  description = "AMI image to be used"
  type        = string
  default     = ""
}

variable "ip_to_be_used_for_rabbitmq" {
  description = "ip"
  type        = string
  default     = ""
}

variable "subnet_id_rabbitmq" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "security_groups_rabbitmq" {
  type    = list(string)
  default = []
}


variable "az_to_be_used_for_rabbitmq" {
  description = "az"
  type        = string
  default     = ""
}


variable "availability_zone_rabbitmq" {
  description = "availability_zone where the instance will be deployed"
  type        = string
  default     = ""
}


############
#PRODUCER A
#############
variable "ami_to_be_used_for_producer_a" {
  description = "AMI image to be used"
  type        = string
  default     = ""
}

variable "ip_to_be_used_for_producer_a" {
  description = "ip"
  type        = string
  default     = ""
}

variable "subnet_id_producer_a" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "security_groups_producer_a" {
  type    = list(string)
  default = []
}


variable "az_to_be_used_for_producer_a" {
  description = "az"
  type        = string
  default     = ""
}


variable "availability_zone_producer_a" {
  description = "availability_zone where the instance will be deployed"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Key pair to be used"
  type        = string
  default     = ""
}



############
#PRODUCER B
#############
variable "ami_to_be_used_for_producer_b" {
  description = "AMI image to be used"
  type        = string
  default     = ""
}

variable "ip_to_be_used_for_producer_b" {
  description = "ip"
  type        = string
  default     = ""
}

variable "subnet_id_producer_b" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "security_groups_producer_b" {
  type    = list(string)
  default = []
}


variable "az_to_be_used_for_producer_b" {
  description = "az"
  type        = string
  default     = ""
}


variable "availability_zone_producer_b" {
  description = "availability_zone where the instance will be deployed"
  type        = string
  default     = ""
}


############
#CONSUMER A
#############
variable "ami_to_be_used_for_consumer_a" {
  description = "AMI image to be used"
  type        = string
  default     = ""
}

variable "ip_to_be_used_for_consumer_a" {
  description = "ip"
  type        = string
  default     = ""
}

variable "subnet_id_consumer_a" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "security_groups_consumer_a" {
  type    = list(string)
  default = []
}


variable "az_to_be_used_for_consumer_a" {
  description = "az"
  type        = string
  default     = ""
}


variable "availability_zone_consumer_a" {
  description = "availability_zone where the instance will be deployed"
  type        = string
  default     = ""
}


############
#CONSUMER B
#############
variable "ami_to_be_used_for_consumer_b" {
  description = "AMI image to be used"
  type        = string
  default     = ""
}

variable "ip_to_be_used_for_consumer_b" {
  description = "ip"
  type        = string
  default     = ""
}

variable "subnet_id_consumer_b" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "security_groups_consumer_b" {
  type    = list(string)
  default = []
}


variable "az_to_be_used_for_consumer_b" {
  description = "az"
  type        = string
  default     = ""
}


variable "availability_zone_consumer_b" {
  description = "availability_zone where the instance will be deployed"
  type        = string
  default     = ""
}