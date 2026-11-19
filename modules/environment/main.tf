locals {
  name_prefix = "ig-${var.environment}"

  # Every per-environment difference lives here.
  settings = {
    dev = {
      subnet_cidr    = "10.10.0.0/24"
      force_destroy  = true
      retention_days = 7
    }
    test = {
      subnet_cidr    = "10.20.0.0/24"
      force_destroy  = true
      retention_days = 7
    }
    run = {
      subnet_cidr    = "10.30.0.0/24"
      force_destroy  = false
      retention_days = 30
    }
  }

  current = local.settings[var.environment]

  common_labels = {
    project     = "infragrid"
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 3
}

module "networking" {
  source = "../networking"

  name_prefix = local.name_prefix
  region      = var.region
  subnet_cidr = local.current.subnet_cidr
}

module "iam" {
  source = "../iam"

  name_prefix = local.name_prefix
  project_id  = var.project_id

  service_accounts = {
    vm = {
      description = "Identity of the ${var.environment} VM"
    }
  }
}

module "storage" {
  source = "../storage"

  name_prefix                       = local.name_prefix
  purpose                           = "artifacts"
  suffix                            = random_id.bucket_suffix.hex
  region                            = var.region
  labels                            = local.common_labels
  force_destroy                     = local.current.force_destroy
  noncurrent_version_retention_days = local.current.retention_days

  object_access = {
    vm = {
      member = module.iam.service_account_members["vm"]
      role   = "roles/storage.objectUser"
    }
  }
}

module "compute" {
  source = "../compute"

  name_prefix           = local.name_prefix
  zone                  = var.zone
  subnet_self_link      = module.networking.subnet_self_link
  service_account_email = module.iam.service_account_emails["vm"]
  network_tags          = [module.networking.iap_ssh_tag]
  labels                = local.common_labels
}
