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
resource "aws_secretsmanager_secret" "hpc_codebuild_github_secret" {
  name        = "hpc_codebuild_github_secret"
  description = "GitHub access token for use in CodeBuild"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "entitycore_service_secrets" {
  name        = "entitycore_service_secrets"
  description = "Secrets for the entitycore service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "obi_generative_gui_service_secrets" {
  name        = "obi_generative_gui_secrets"
  description = "Secrets for the obi-generative-gui service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "notebook_service_secrets" {
  name        = "notebook_service_secrets_v2"
  description = "Secrets for the notebook service"
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "launch_service_secrets" {
  name        = "launch_service_secrets_v2"
  description = "Secrets for the launch service"
}
