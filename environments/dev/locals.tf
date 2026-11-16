locals {
  environment = "dev"
  name_prefix = "ig-${local.environment}"


  common_labels = {
    project     = "infragrid"
    environment = local.environment
    managed_by  = "terraform"
  }
}
