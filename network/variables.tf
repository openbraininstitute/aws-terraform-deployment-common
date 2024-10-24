variable "vpc_name" {
  type      = string
  sensitive = false
}
variable "vpc_cidr_block" {
  type      = string
  sensitive = false
}
variable "igw_name" {
  type      = string
  sensitive = false
  default   = "igw"
}
variable "aws_region" {
  type      = string
  sensitive = false
}
variable "public_subnet_1_cidr_block" {
  type      = string
  sensitive = false
}
variable "public_subnet_1_name" {
  type      = string
  sensitive = false
  default   = "public_a"
}
variable "public_subnet_1_availability_zone" {
  type      = string
  sensitive = false
  default   = "a"
}
variable "public_subnet_2_cidr_block" {
  type      = string
  sensitive = false
}
variable "public_subnet_2_name" {
  type      = string
  sensitive = false
  default   = "public_b"
}
variable "public_subnet_2_availability_zone" {
  type      = string
  sensitive = false
  default   = "b"
}
variable "public_route_name" {
  type      = string
  sensitive = false
  default   = "public"
}
variable "nat_name" {
  type      = string
  sensitive = false
  default   = "nat"
}
variable "nat_eip_name" {
  type      = string
  sensitive = false
  default   = "nat_eip"
}
