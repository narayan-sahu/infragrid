locals {
  common_labels = {
    project     = "infragrid"
    environment = var.environment
    managed_by  = "terraform"
  }
}