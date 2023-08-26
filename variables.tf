variable "region" {
    description = "vpc region"
    default     ="eu-west-2"

}

variable "vpc_cidar" {
    description = "vpc cidr block"
    default     ="10.0.0.0/16"

}

variable "Prod-pub-sub-1" {
    description = "public subnet 1"
    default     ="10.0.1.0/24"

}



variable "Prod-pub-sub-2" {
    description = "public subnet 2"
    default     ="10.0.2.0/24"

}

variable "Prod-pri-sub-1" {
    description = "private subnet 1"
    default     ="10.0.3.0/24"

}

variable "prod-pri-sub-2" {
    description = "private subnet 2"
    default     ="10.0.4.0/24"

}