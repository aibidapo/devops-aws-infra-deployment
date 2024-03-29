variable "vpc_cidr" {
  type        = string
  description = "cidr address of the vpc"
  default     = "10.124.0.0/16"
}

variable "access_ip" {
  type        = string
  default     = "85.237.194.6/32"
  description = "This is the public IP address of the pc used to access your AWS account"
  # Note that your public address might change from time to time.
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