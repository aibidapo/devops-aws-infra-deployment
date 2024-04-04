variable "vpc_cidr" {
  type        = string
  description = "cidr address of the vpc"
  default     = "10.123.0.0/16"
}

variable "my_ip" {
  type = string
  default = "75.86.93.55/32"
  description = "This is the public IP address of the pc used to access your AWS account"
  # Note that your public address might change from time to time.  
}
variable "access_ip" {
  type        = string
  default     = "0.0.0.0/0"

}

variable "main_instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "main_vol_size" {
  type    = number
  default = 8
}

variable "main_instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
  # default = "value" <-- Defined in terraform.tfvars
}

variable "public_key_path" {
  type = string
  # default = <-- Defined in terraform.tfvars
}