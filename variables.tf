variable "instance_type" {
  type = list(string)
  default = ["t2.micro","t3.micro"]

}

variable "instance_type_map" {
  type = map(string)
  default = {
    "dev" = "t2.micro"
    "prod" = "t3.micro"

  }
}
