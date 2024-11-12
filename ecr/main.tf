# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "hpc-resource-provisioner-ecr" {
  name = "hpc/resource-provisioner"

  # mutable, because otherwise we can't update `latest`
  # see https://github.com/aws/containers-roadmap/issues/878
  image_tag_mutability = "MUTABLE" # tfsec:ignore:aws-ecr-enforce-immutable-repository
  image_scanning_configuration {
    scan_on_push = false # tfsec:ignore:aws-ecr-enable-image-scans
  }
}

data "aws_ecr_lifecycle_policy_document" "expire_images" {
  rule {
    priority    = 1
    description = "Expire all but the 10 most recent images"
    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 10
    }
  }
}

resource "aws_ecr_lifecycle_policy" "hpc-resource-provisioner-ecr-lifecycle-policy" {
  repository = aws_ecr_repository.hpc-resource-provisioner-ecr.name
  policy     = data.aws_ecr_lifecycle_policy_document.expire_images.json
}
