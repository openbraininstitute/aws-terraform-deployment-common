resource "local_file" "generated_variables_with_values" {
  content = templatefile("generate-variables-with-values.tmpl",
    {
      sbo_vpc = aws_vpc.sbo_poc,
      subnets = [aws_subnet.public_a, aws_subnet.public_b]
    }
  )
  filename = "generated/variables-with-values.tf"
}

resource "local_file" "generated_variables_without_values" {
  content = templatefile("generate-variables-without-values.tmpl",
    {
      sbo_vpc = aws_vpc.sbo_poc,
      subnets = [aws_subnet.public_a, aws_subnet.public_b]
    }
  )
  filename = "generated/variables-without-values.tf"
}

resource "local_file" "generated_values" {
  content = templatefile("generate-values.tmpl",
    {
      sbo_vpc = aws_vpc.sbo_poc,
      subnets = [aws_subnet.public_a, aws_subnet.public_b]
    }
  )
  filename = "generated/values.tfvars"
}
