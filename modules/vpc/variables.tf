variable "enviroment_name" {
  description = "Enviroment Name"
  type        = string
  default     = "Eaton-SecureConnect-DEV"
}


variable "tags_to_be_applied" {
  description = "Tags to be applied"
  type        = map(string)
  default = {
    Environment  = "DEV"
    Project      = "EatonSecureConnect"
    CreatedBy    = "Fabio Boaretti"
    CreatedUsing = "terraform"
    Version = "1.0"
  }
}
