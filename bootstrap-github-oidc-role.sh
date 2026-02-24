#!/bin/bash
# Bootstrap script to create GitHub OIDC role for Terraform deployments
# Run this once manually with admin credentials before enabling OIDC in workflows

set -e

echo "Creating GitHub OIDC role for aws-terraform-deployment-common..."

# Check if OIDC provider exists
OIDC_PROVIDER_ARN=$(aws iam list-open-id-connect-providers --query "OpenIDConnectProviderList[?contains(Arn, 'token.actions.githubusercontent.com')].Arn" --output text)

if [ -z "$OIDC_PROVIDER_ARN" ]; then
  echo "Creating GitHub OIDC provider..."
  OIDC_PROVIDER_ARN=$(aws iam create-open-id-connect-provider \
    --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com \
    --query 'OpenIDConnectProviderArn' --output text)
  echo "Created OIDC provider: $OIDC_PROVIDER_ARN"
else
  echo "OIDC provider already exists: $OIDC_PROVIDER_ARN"
fi

# Create trust policy
cat > /tmp/trust-policy.json <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "$OIDC_PROVIDER_ARN"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:openbraininstitute/aws-terraform-deployment-common:*"
        }
      }
    }
  ]
}
POLICY

# Create role
ROLE_NAME="GithubTerraformDeployCommon"
if aws iam get-role --role-name $ROLE_NAME 2>/dev/null; then
  echo "Role $ROLE_NAME already exists"
else
  echo "Creating role $ROLE_NAME..."
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file:///tmp/trust-policy.json \
    --description "GitHub Actions role for aws-terraform-deployment-common"
fi

# Attach admin policy (adjust as needed)
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text)

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Role ARN: $ROLE_ARN"
echo ""
echo "Hardcode this ARN in your GitHub workflows:"
echo "   role-to-assume: $ROLE_ARN"
