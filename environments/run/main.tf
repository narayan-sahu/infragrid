# The run environment is production-style: validated only, never applied from a workstation.

resource "random_id" "bucket_suffix" {
  byte_length = 3
}

module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix
  region      = var.region
  subnet_cidr = var.subnet_cidr
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix
  project_id  = var.project_id

  service_accounts = {
    vm = {
      description = "Identity of the ${local.environment} VM"
    }
  }
}

module "storage" {
  source = "../../modules/storage"

  name_prefix   = local.name_prefix
  purpose       = "artifacts"
  suffix        = random_id.bucket_suffix.hex
  region        = var.region
  labels        = local.common_labels
  force_destroy = true # dev is disposable; teardown must work

  object_access = {
    vm = {
      member = module.iam.service_account_members["vm"]
      role   = "roles/storage.objectUser"
    }
  }
}

module "compute" {
  source = "../../modules/compute"

  name_prefix           = local.name_prefix
  zone                  = var.zone
  subnet_self_link      = module.networking.subnet_self_link
  service_account_email = module.iam.service_account_emails["vm"]
  network_tags          = [module.networking.iap_ssh_tag]
  labels                = local.common_labels
}
