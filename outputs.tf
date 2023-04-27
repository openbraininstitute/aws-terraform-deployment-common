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
