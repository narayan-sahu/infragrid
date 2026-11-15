locals {
  role_bindings = flatten([
    for key, sa in var.service_accounts : [
      for role in sa.project_roles : {
        account = key
        role    = role
      }
    ]
  ])
}

resource "google_service_account" "this" {
  for_each = var.service_accounts

  account_id   = "${var.name_prefix}-${each.key}-svc"
  display_name = "${var.name_prefix} ${each.key}"
  description  = each.value.description
}

resource "google_project_iam_member" "this" {
  for_each = { for b in local.role_bindings : "${b.account}|${b.role}" => b }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.this[each.value.account].email}"
}
