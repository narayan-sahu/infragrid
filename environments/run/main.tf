# The run environment is production-style: validated only, never applied from a workstation.

module "environment" {
  source = "../../modules/environment"

  environment = "run"
  project_id  = var.project_id
  region      = var.region
  zone        = var.zone
}
