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
}
