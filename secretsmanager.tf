#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "dockerhub_bbpbuildbot_secret" {
  name        = "dockerhub_bbpbuildbot_credentials"
  description = "dockerhub bbpbuildbot user credentials"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "virtual_lab_manager_secrets" {
  name        = "virtual_lab_manager_secrets"
  description = "Secrets for the virtual lab manager service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "keycloak_secrets" {
  name        = "keycloak_secrets"
  description = "Secret for the Keycloak service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "core_webapp_secrets" {
  name        = "core_web_app_secrets"
  description = "Secret for the core-webapp service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "ml_secrets_manager" {
  name        = "machine_learning_secrets"
  description = "Secrets for ML services"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "accounting_service_secrets" {
  name        = "accounting_service_secrets"
  description = "Secrets for the accounting service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "bluenaas_service_secrets" {
  name        = "bluenaas_service_secrets"
  description = "Secrets for the bluenaas service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "hpc_slurm_secrets" {
  name        = "hpc_slurm_secrets"
  description = "Slurm database password"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "nexus_secrets" {
  name        = "nexus_service_secrets"
  description = "Secrets for the Nexus service"
}
