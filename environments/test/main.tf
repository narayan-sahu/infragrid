module "environment" {
  source = "../../modules/environment"

  environment = "test"
  project_id  = var.project_id
  region      = var.region
  zone        = var.zone
}
