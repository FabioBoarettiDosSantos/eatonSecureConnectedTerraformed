variable "list_of_SG" {
  description = "List of SG"
  type        = list(string)
  default = [ ]
}

variable "list_of_subnets" {
  description = "List of Subnets"
  type        = list(string)
  default = [ ]
}

variable "rds_kms_key_id_arn" {
  description = "Kms Key Id arn"
  type        = string
  default = ""
}


variable "availability_zones" {
  description = "List of AZ"
  type        = list(string)
  default = [ ]
}

