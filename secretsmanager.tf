#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "virtual_lab_manager_secrets" {
  name        = "virtual_lab_manager_secrets"
  description = "Secrets for the virtual lab manager service"
  tags        = { SBO_Billing = "virtual_lab_manager" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "virtual_lab_manager_database_readonly_secret" {
  name        = "virtual_lab_manager_database_readonly_secret"
  description = "Secret containing a username and password for read-only access to the virtual-lab-manager database"
  tags        = { SBO_Billing = "virtual_lab_manager" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "accounting_database_readonly_secret" {
  name        = "accounting_database_readonly_secret"
  description = "Secret containing a username and password for read-only access to the accounting database"
  tags        = { SBO_Billing = "accounting" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "keycloak_secrets" {
  name        = "keycloak_secrets"
  description = "Secret for the Keycloak service"
  tags        = { SBO_Billing = "keycloak" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "jupyterhub_secrets" {
  name        = "jupyterhub_secrets"
  description = "Secrets for the JupyterHub service"
  tags        = { SBO_Billing = "jupyterhub" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "core_webapp_secrets" {
  name        = "core_web_app_secrets"
  description = "Secret for the core-webapp service"
  tags        = { SBO_Billing = "core_webapp" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "grading_service_secrets" {
  name        = "grading_service_secrets"
  description = "Secret for the grading service"
  tags        = { SBO_Billing = "core_webapp" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "ml_secrets_manager" {
  name        = "machine_learning_secrets"
  description = "Secrets for ML services"
  tags        = { SBO_Billing = "machinelearning" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "accounting_service_secrets" {
  name        = "accounting_service_secrets"
  description = "Secrets for the accounting service"
  tags        = { SBO_Billing = "accounting" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "small_scale_simulator_secrets" {
  name        = "small_scale_simulator_secrets"
  description = "Secrets for the small_scale_simulator"
  tags        = { SBO_Billing = "small_scale_simulator" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "hpc_slurm_secrets" {
  name        = "hpc_slurm_secrets"
  description = "Slurm database password"
  tags        = { SBO_Billing = "hpc" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "entitycore_service_secrets" {
  name        = "entitycore_service_secrets"
  description = "Secrets for the entitycore service"
  tags        = { SBO_Billing = "entitycore" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "notebook_service_secrets" {
  name        = "notebook_service_secrets_v2"
  description = "Secrets for the notebook service"
  tags        = { SBO_Billing = "notebook_service" }
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "launch_system_secrets" {
  name        = "launch_system_secrets"
  description = "Secrets for the launch system"
  tags        = { SBO_Billing = "launch_system" }
}

resource "aws_secretsmanager_secret" "launch_system_executor_secrets" {
  name        = "launch_system_executor_secrets"
  description = "Secrets for the launch system executors"
  tags        = { SBO_Billing = "launch_system" }
}

resource "aws_secretsmanager_secret" "teams_webhook_secrets" {
  name        = "teams_webhook_secrets"
  description = "The webhooks of Teams to send SNS messages to Teams channels"
}

resource "aws_secretsmanager_secret" "auth_manager_secrets" {
  name        = "auth_manager_secrets"
  description = "Secrets for the Auth Manager service"
  tags        = { SBO_Billing = "auth_manager_svc" }
}

resource "aws_secretsmanager_secret" "obi_one_secrets" {
  name        = "obi_one_secrets"
  description = "Secrets for the obi-one service"
  tags        = { SBO_Billing = "obi_one_v2" }
}
