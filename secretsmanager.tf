#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "virtual_lab_manager_secrets" {
  name        = "virtual_lab_manager_secrets"
  description = "Secrets for the virtual lab manager service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "virtual_lab_manager_database_readonly_secret" {
  name        = "virtual_lab_manager_database_readonly_secret"
  description = "Secret containing a username and password for read-only access to the virtual-lab-manager database"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "accounting_database_readonly_secret" {
  name        = "accounting_database_readonly_secret"
  description = "Secret containing a username and password for read-only access to the accounting database"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "keycloak_secrets" {
  name        = "keycloak_secrets"
  description = "Secret for the Keycloak service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "jupyterhub_secrets" {
  name        = "jupyterhub_secrets"
  description = "Secrets for the JupyterHub service"
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
resource "aws_secretsmanager_secret" "small_scale_simulator_secrets" {
  name        = "small_scale_simulator_secrets"
  description = "Secrets for the small_scale_simulator"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "hpc_slurm_secrets" {
  name        = "hpc_slurm_secrets"
  description = "Slurm database password"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "entitycore_service_secrets" {
  name        = "entitycore_service_secrets"
  description = "Secrets for the entitycore service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "notebook_service_secrets" {
  name        = "notebook_service_secrets_v2"
  description = "Secrets for the notebook service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "launch_system_secrets" {
  name        = "launch_system_secrets"
  description = "Secrets for the launch system"
}

resource "aws_secretsmanager_secret" "launch_system_executor_secrets" {
  name        = "launch_system_executor_secrets"
  description = "Secrets for the launch system executors"
}

resource "aws_secretsmanager_secret" "teams_webhook_secrets" {
  name        = "teams_webhook_secrets"
  description = "The webhooks of Teams to send SNS messages to Teams channels"
}

resource "aws_secretsmanager_secret" "auth_manager_secrets" {
  name        = "auth_manager_secrets"
  description = "Secrets for the Auth Manager service"
}
