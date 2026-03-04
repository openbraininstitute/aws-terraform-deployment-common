# The outputs defined here can be used by other modules/repos
output "nat_gateway_id" {
  description = "ID of the NAT gateway for private networks"
  value       = module.network.nat_gateway_id
}

output "public_a_subnet_id" {
  description = "ID of the public_a subnet"
  value       = module.network.public_1_subnet_id
  sensitive   = false
}

output "public_a_subnet_arn" {
  description = "ARN of the public_a subnet"
  value       = module.network.public_1_subnet_arn
}

output "public_b_subnet_id" {
  description = "ID of the public_b subnet"
  value       = module.network.public_2_subnet_id
}

output "public_b_subnet_arn" {
  description = "ARN of the public_b subnet"
  value       = module.network.public_2_subnet_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block or network range of the VPC"
  value       = module.network.vpc_cidr_block
}

output "vpc_default_sg_id" {
  description = "ID of the Default Security Group for the VPC"
  value       = module.network.vpc_default_sg_id
}

output "route_table_private_subnets_id" {
  description = "ID of the route table for all private subnets in the main region"
  value       = module.network.private_route_table_id
}

output "route_table_public_id" {
  description = "ID of the route table for all public subnets in the main region"
  value       = module.network.public_route_table_id
}

output "primary_domain" {
  description = "Primary platform domain"
  value       = var.primary_domain_name
  sensitive   = false
}

output "preview_domain" {
  description = "preview domain name"
  value       = var.is_staging ? module.preview_openbraininstitute_org[0].domain_name : null
  sensitive   = false
}

output "preview_domain_zone_id" {
  description = "zone_id of the preview domain"
  value       = var.is_staging ? module.preview_openbraininstitute_org[0].domain_zone_id : null
  sensitive   = false
}

output "private_alb_https_listener_arn" {
  description = "ARN of the private ALB"
  value       = module.private_alb_basic.alb_https_listener_arn
}

output "generic_private_alb_security_group_id" {
  description = "Id of the SG of the new private ALB"
  value       = module.private_alb_basic.alb_securitygroup_id
}

output "virtual_lab_manager_secrets_arn" {
  description = "ARN of the Virtual La  secrets manager service"
  value       = aws_secretsmanager_secret.virtual_lab_manager_secrets.arn
}

output "virtual_lab_manager_database_readonly_secret_arn" {
  description = "ARN of the secret containing a username and password for read-only access to the virtual lab manager database"
  value       = aws_secretsmanager_secret.virtual_lab_manager_database_readonly_secret.arn
}

output "accounting_database_readonly_secret_arn" {
  description = "ARN of the secret containing a username and password for read-only access to the accounting database"
  value       = aws_secretsmanager_secret.accounting_database_readonly_secret.arn
}


output "keycloak_secrets_arn" {
  description = "ARN of the Keycloak secrets manager"
  value       = aws_secretsmanager_secret.keycloak_secrets.arn
}

output "jupyterhub_secrets_arn" {
  description = "ARN of the JupyterHub secrets manager"
  value       = aws_secretsmanager_secret.jupyterhub_secrets.arn
}

output "core_webapp_secrets_arn" {
  description = "ARN of the core-webapp secrets manager"
  value       = aws_secretsmanager_secret.core_webapp_secrets.arn
}

output "ml_secrets_arn" {
  description = "ARN of the ML secrets manager"
  value       = aws_secretsmanager_secret.ml_secrets_manager.arn
}

output "accounting_service_secrets_arn" {
  description = "ARN of the accounting_service secrets manager"
  value       = aws_secretsmanager_secret.accounting_service_secrets.arn
}

output "small_scale_simulator_secrets_arn" {
  description = "ARN of the small_scale_simulator secrets manager"
  value       = aws_secretsmanager_secret.small_scale_simulator_secrets.arn
}

output "hpc_slurm_secrets_arn" {
  description = "ARN of the HPC Slurm secrets manager"
  value       = aws_secretsmanager_secret.hpc_slurm_secrets.arn
}

output "entitycore_service_secrets_arn" {
  description = "ARN of the entitycore_service secrets manager"
  value       = aws_secretsmanager_secret.entitycore_service_secrets.arn
}
output "notebook_service_secrets_arn" {
  description = "ARN of the secrets of the notebooks service"
  value       = aws_secretsmanager_secret.notebook_service_secrets.arn
}

output "email_domain_name" {
  description = "domain used for sending mails from the platform, mainly to send no-reply@ emails"
  value       = var.email_domain_name
}

output "launch_system_secrets_arn" {
  description = "ARN of the secrets of the launch system"
  value       = aws_secretsmanager_secret.launch_system_secrets.arn
}

output "teams_webhook_secrets_arn" {
  description = "ARN of the secret with the teams webhooks"
  value       = aws_secretsmanager_secret.teams_webhook_secrets.arn
}

output "auth_manager_secrets_arn" {
  description = "ARN of the secrets of the auth manager service"
  value       = aws_secretsmanager_secret.auth_manager_secrets.arn
}

output "private_alb_cidr_a" {
  value       = aws_subnet.private_alb_a.cidr_block
  description = "CIDR block of the first subnet containing the private ALB"
}

output "private_alb_cidr_b" {
  value       = aws_subnet.private_alb_b.cidr_block
  description = "CIDR block of the second subnet containing the private ALB"
}

# For debugging purposes
output "alternative_hostnames" {
  value = module.alternative_hostnames
}
