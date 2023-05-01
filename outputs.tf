# The outputs defined here can be used by other modules/repos

output "aws_region" {
  description = "AWS region to use"
  value       = var.aws_region
}

# Dummy variable mostly for testing purposes
output "dummy_test_output" {
  description = "A dummy output for remote tests"
  value       = "Core Services Dummy Test Output"
}

output "aws_coreservices_ssh_key_id" {
  description = "ID of the SSH key aws_resources"
  value       = aws_key_pair.aws_coreservices.id
}

output "aws_coreservices_ssh_key_arn" {
  description = "ARN of the SSH key aws_resources"
  value       = aws_key_pair.aws_coreservices.arn
}
