locals {
  environment = "dev"

  common_labels = {
    project     = "infragrid"
    environment = local.environment
    managed_by  = "terraform"
  }
}
