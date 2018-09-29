terraform {
  backend "s3" {
    bucket = "terraform-infra-pipeline"
    key = "versionv1"
  }
}
