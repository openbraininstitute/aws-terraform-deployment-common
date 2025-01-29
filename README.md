<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.75.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alt_domain_openbluebrain_ch"></a> [alt\_domain\_openbluebrain\_ch](#module\_alt\_domain\_openbluebrain\_ch) | ./domain | n/a |
| <a name="module_alt_domain_openbrainplatform_com"></a> [alt\_domain\_openbrainplatform\_com](#module\_alt\_domain\_openbrainplatform\_com) | ./domain | n/a |
| <a name="module_alt_domain_openbrainplatform_org"></a> [alt\_domain\_openbrainplatform\_org](#module\_alt\_domain\_openbrainplatform\_org) | ./domain | n/a |
| <a name="module_alt_private_domain_openbluebrain_ch"></a> [alt\_private\_domain\_openbluebrain\_ch](#module\_alt\_private\_domain\_openbluebrain\_ch) | ./private_domain | n/a |
| <a name="module_alt_private_domain_openbrainplatform_com"></a> [alt\_private\_domain\_openbrainplatform\_com](#module\_alt\_private\_domain\_openbrainplatform\_com) | ./private_domain | n/a |
| <a name="module_alt_private_domain_openbrainplatform_org"></a> [alt\_private\_domain\_openbrainplatform\_org](#module\_alt\_private\_domain\_openbrainplatform\_org) | ./private_domain | n/a |
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ./ecr | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./network | n/a |
| <a name="module_openbluebrain_ch_cert"></a> [openbluebrain\_ch\_cert](#module\_openbluebrain\_ch\_cert) | ./tls_certificate | n/a |
| <a name="module_openbluebrain_com_cert"></a> [openbluebrain\_com\_cert](#module\_openbluebrain\_com\_cert) | ./tls_certificate | n/a |
| <a name="module_openbrainplatform_com_cert"></a> [openbrainplatform\_com\_cert](#module\_openbrainplatform\_com\_cert) | ./tls_certificate | n/a |
| <a name="module_openbrainplatform_org_cert"></a> [openbrainplatform\_org\_cert](#module\_openbrainplatform\_org\_cert) | ./tls_certificate | n/a |
| <a name="module_primary_domain"></a> [primary\_domain](#module\_primary\_domain) | ./domain | n/a |
| <a name="module_private_alb_basic"></a> [private\_alb\_basic](#module\_private\_alb\_basic) | ./obp_private_alb_basic | n/a |
| <a name="module_private_alb_config"></a> [private\_alb\_config](#module\_private\_alb\_config) | ./obp_private_alb_config | n/a |
| <a name="module_private_primary_domain"></a> [private\_primary\_domain](#module\_private\_primary\_domain) | ./private_domain | n/a |
| <a name="module_public_nlb_basic"></a> [public\_nlb\_basic](#module\_public\_nlb\_basic) | ./obp_public_nlb_basic | n/a |
| <a name="module_public_nlb_config"></a> [public\_nlb\_config](#module\_public\_nlb\_config) | ./obp_public_nlb_config | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./s3 | n/a |
| <a name="module_www_openbluebrain_ch_cert"></a> [www\_openbluebrain\_ch\_cert](#module\_www\_openbluebrain\_ch\_cert) | ./tls_certificate | n/a |
| <a name="module_www_openbluebrain_com_cert"></a> [www\_openbluebrain\_com\_cert](#module\_www\_openbluebrain\_com\_cert) | ./tls_certificate | n/a |
| <a name="module_www_openbrainplatform_com_cert"></a> [www\_openbrainplatform\_com\_cert](#module\_www\_openbrainplatform\_com\_cert) | ./tls_certificate | n/a |
| <a name="module_www_openbrainplatform_org_cert"></a> [www\_openbrainplatform\_org\_cert](#module\_www\_openbrainplatform\_org\_cert) | ./tls_certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.dockerhub_credentials_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_lb.private_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.private_alb_3000](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_network_acl.private_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route_table_association.private_alb_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_alb_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.accounting_service_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.bluenaas_service_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.core_webapp_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.dockerhub_bbpbuildbot_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.hpc_codebuild_github_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.hpc_slurm_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.keycloak_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.ml_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.nexus_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.virtual_lab_manager_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.workflow_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_security_group.private_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_alb_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_alb_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_security_group_egress_rule.private_alb_allow_everything_outgoing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.public_allow_everything_outgoing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_alb_allow_3000_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_allow_http_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_allow_https_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_allow_ssh_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alt_domain_openbluebrain_ch_name"></a> [alt\_domain\_openbluebrain\_ch\_name](#input\_alt\_domain\_openbluebrain\_ch\_name) | n/a | `string` | n/a | yes |
| <a name="input_alt_domain_openbrainplatform_com_name"></a> [alt\_domain\_openbrainplatform\_com\_name](#input\_alt\_domain\_openbrainplatform\_com\_name) | n/a | `string` | n/a | yes |
| <a name="input_alt_domain_openbrainplatform_org_name"></a> [alt\_domain\_openbrainplatform\_org\_name](#input\_alt\_domain\_openbrainplatform\_org\_name) | n/a | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_nlb_logs_bucket_name"></a> [nlb\_logs\_bucket\_name](#input\_nlb\_logs\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_primary_domain_name"></a> [primary\_domain\_name](#input\_primary\_domain\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounting_service_secrets_arn"></a> [accounting\_service\_secrets\_arn](#output\_accounting\_service\_secrets\_arn) | ARN of the accounting\_service secrets manager |
| <a name="output_bluenaas_service_secrets_arn"></a> [bluenaas\_service\_secrets\_arn](#output\_bluenaas\_service\_secrets\_arn) | ARN of the bluenaas secrets manager |
| <a name="output_core_webapp_secrets_arn"></a> [core\_webapp\_secrets\_arn](#output\_core\_webapp\_secrets\_arn) | ARN of the core-webapp secrets manager |
| <a name="output_dockerhub_bbpbuildbot_policy_arn"></a> [dockerhub\_bbpbuildbot\_policy\_arn](#output\_dockerhub\_bbpbuildbot\_policy\_arn) | ARN of the dockerhub\_bbpbuildbot policy |
| <a name="output_dockerhub_bbpbuildbot_secret_arn"></a> [dockerhub\_bbpbuildbot\_secret\_arn](#output\_dockerhub\_bbpbuildbot\_secret\_arn) | ARN of the dockerhub\_bbpbuildbot secrets manager |
| <a name="output_generic_private_alb_security_group_id"></a> [generic\_private\_alb\_security\_group\_id](#output\_generic\_private\_alb\_security\_group\_id) | Id of the SG of the new private ALB |
| <a name="output_hpc_codebuild_github_secret_arn"></a> [hpc\_codebuild\_github\_secret\_arn](#output\_hpc\_codebuild\_github\_secret\_arn) | ARN of the HPC CodeBuild/GitHub secret |
| <a name="output_hpc_slurm_secrets_arn"></a> [hpc\_slurm\_secrets\_arn](#output\_hpc\_slurm\_secrets\_arn) | ARN of the HPC Slurm secrets manager |
| <a name="output_keycloak_secrets_arn"></a> [keycloak\_secrets\_arn](#output\_keycloak\_secrets\_arn) | ARN of the Keycloak secrets manager |
| <a name="output_ml_secrets_arn"></a> [ml\_secrets\_arn](#output\_ml\_secrets\_arn) | ARN of the ML secrets manager |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | ID of the NAT gateway for private networks |
| <a name="output_nexus_secrets_arn"></a> [nexus\_secrets\_arn](#output\_nexus\_secrets\_arn) | ARN of the Nexus secrets manager |
| <a name="output_primary_domain"></a> [primary\_domain](#output\_primary\_domain) | Primary platform domain |
| <a name="output_primary_domain_zone_id"></a> [primary\_domain\_zone\_id](#output\_primary\_domain\_zone\_id) | zone\_id of the primary domain |
| <a name="output_private_alb_dns_name"></a> [private\_alb\_dns\_name](#output\_private\_alb\_dns\_name) | DNS name of the private application load balancer |
| <a name="output_private_alb_https_listener_arn"></a> [private\_alb\_https\_listener\_arn](#output\_private\_alb\_https\_listener\_arn) | ARN of the private ALB |
| <a name="output_private_alb_listener_3000_arn"></a> [private\_alb\_listener\_3000\_arn](#output\_private\_alb\_listener\_3000\_arn) | ARN of the listener on port 3000 for the private application load balancer |
| <a name="output_private_alb_listener_3000_id"></a> [private\_alb\_listener\_3000\_id](#output\_private\_alb\_listener\_3000\_id) | ID of the listener on port 3000 for the private application load balancer |
| <a name="output_private_alb_security_group_id"></a> [private\_alb\_security\_group\_id](#output\_private\_alb\_security\_group\_id) | ID of the SG of the private ALB |
| <a name="output_public_a_subnet_arn"></a> [public\_a\_subnet\_arn](#output\_public\_a\_subnet\_arn) | ARN of the public\_a subnet |
| <a name="output_public_a_subnet_id"></a> [public\_a\_subnet\_id](#output\_public\_a\_subnet\_id) | ID of the public\_a subnet |
| <a name="output_public_b_subnet_arn"></a> [public\_b\_subnet\_arn](#output\_public\_b\_subnet\_arn) | ARN of the public\_b subnet |
| <a name="output_public_b_subnet_id"></a> [public\_b\_subnet\_id](#output\_public\_b\_subnet\_id) | ID of the public\_b subnet |
| <a name="output_public_nlb_sg_id"></a> [public\_nlb\_sg\_id](#output\_public\_nlb\_sg\_id) | Id of NLB security group |
| <a name="output_route_table_private_subnets_id"></a> [route\_table\_private\_subnets\_id](#output\_route\_table\_private\_subnets\_id) | ID of the route table for all private subnets in the main region |
| <a name="output_virtual_lab_manager_secrets_arn"></a> [virtual\_lab\_manager\_secrets\_arn](#output\_virtual\_lab\_manager\_secrets\_arn) | ARN of the Virtual La  secrets manager service |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR block or network range of the VPC |
| <a name="output_vpc_default_sg_id"></a> [vpc\_default\_sg\_id](#output\_vpc\_default\_sg\_id) | ID of the Default Security Group for the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
| <a name="output_workflow_service_secrets_arn"></a> [workflow\_service\_secrets\_arn](#output\_workflow\_service\_secrets\_arn) | ARN of the workflow secrets manager |
<!-- END_TF_DOCS -->

# Funding and Acknowledgement

The development of this software was supported by funding to the Blue Brain Project, a research center of the École polytechnique fédérale de Lausanne (EPFL), from the Swiss government’s ETH Board of the Swiss Federal Institutes of Technology.

Copyright (c) 2025 Open Brain Institute
