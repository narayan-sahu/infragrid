module "environment" {
  source = "../../modules/environment"

  environment = "dev"
  project_id  = var.project_id
  region      = var.region
  zone        = var.zone
}
