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
