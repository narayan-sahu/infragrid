# networking

Custom-mode VPC, one subnet with Private Google Access, and a firewall rule
that allows SSH only from Google's IAP range. No external access is opened.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name_prefix` | string | none | Prefix for resource names, for example `ig-dev` |
| `region` | string | none | Region of the subnet |
| `subnet_cidr` | string | none | Private (RFC 1918) IPv4 range of the subnet |
| `iap_ssh_tag` | string | `ig-iap-ssh` | Network tag that grants IAP SSH access |

## Outputs

| Name | Description |
|---|---|
| `network_self_link` | Self link of the VPC network |
| `subnet_self_link` | Self link of the subnet |
| `iap_ssh_tag` | Network tag for IAP SSH access |
| `subnet_cidr` | IPv4 range of the subnet |

## Usage

    module "networking" {
      source      = "../../modules/networking"
      name_prefix = "ig-dev"
      region      = var.region
      subnet_cidr = "10.10.0.0/24"
    }

## Notes

- Not included on purpose: Cloud NAT, flow logs, egress rules.
- New projects may contain a default network with permissive firewall rules.
  That is not managed here (see the runbook when the project is created).
- Tests: `terraform test` from this directory. They use a mock provider and
  need no credentials.
