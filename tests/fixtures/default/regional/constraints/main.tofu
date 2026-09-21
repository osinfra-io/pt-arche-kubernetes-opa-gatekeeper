# Required Providers
# https://opentofu.org/docs/language/providers/requirements

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Kubernetes OPA Gatekeeper Constraints
# https://github.com/osinfra-io/pt-arche-kubernetes-opa-gatekeeper

module "test" {
  source = "../../../../../regional/constraints"

  allowed_groups = ["platform-admins"]
  allowed_users  = ["platform-deployer@example.iam.gserviceaccount.com"]

  protected_kinds = [
    {
      apiGroup = "security.istio.io"
      kind     = "AuthorizationPolicy"
    },
  ]

  protected_namespaces = ["identity"]
}
