data "aws_ec2_instance_type_offerings" "instance_offerings" {

for_each = toset(["ap-south-1a","ap-south-1b","ap-south-1c"])

    filter {
      name   = "instance-type"
      values = ["t2.micro"]
    }

    filter {
      name   = "location"
      values = [each.key]
    }

    location_type = "availability-zone"
  }


#output -1 showing the AZ's that are supported for t2.micro and those not supports shows blank against AZ

output "offerings_instance_type-without_if" {
  value = {for az,instance in data.aws_ec2_instance_type_offerings.instance_offerings: az => instance.instance_types}
}

#output -2  showing the AZ's with instance_type  that are supported for t2.micro only , AZ's omitted which not supports

output "offerings_instance_type_if_condition" {
  value = {for az,instance in data.aws_ec2_instance_type_offerings.instance_offerings:
  az => instance.instance_types if length(instance.instance_types) != 0}
}

#output 3 - Using keys() function to get AZ names only that supports t2.micro
#you can also use values() function to get map's values

output "offerings_instance_type_keys_function" {
  value = keys({for az,instance in data.aws_ec2_instance_type_offerings.instance_offerings:
  az => instance.instance_types if length(instance.instance_types) != 0})
}




# output -4 pick single AZ from list of AZ supported t2.micro
# #value =  values(aws_instance.myec2)[*].public_ip

output "AZ-single-supported-t2-micro" {
  value = keys({for az,instance in data.aws_ec2_instance_type_offerings.instance_offerings:
  az => instance.instance_types if length(instance.instance_types) != 0}) [0]
}
