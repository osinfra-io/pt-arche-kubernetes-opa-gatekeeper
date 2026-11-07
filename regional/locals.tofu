# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  helm_values = {
    audit = {
      podLabels = {
        "tags.datadoghq.com/manager.service" = "gatekeeper-audit"
      }

      resources = {
        limits = {
          cpu    = var.audit_resources_limits_cpu
          memory = var.audit_resources_limits_memory
        }

        requests = {
          cpu    = var.audit_resources_requests_cpu
          memory = var.audit_resources_requests_memory
        }
      }
    }

    controllerManager = {
      podLabels = {
        "tags.datadoghq.com/manager.service" = "gatekeeper-controller-manager"
      }

      resources = {
        limits = {
          cpu    = var.controller_manager_resources_limits_cpu
          memory = var.controller_manager_resources_limits_memory
        }

        requests = {
          cpu    = var.controller_manager_resources_requests_cpu
          memory = var.controller_manager_resources_requests_memory
        }
      }
    }

    image = {
      crdRepository = "${var.artifact_registry}/openpolicyagent/gatekeeper-crds"
      release       = var.gatekeeper_version
      repository    = "${var.artifact_registry}/openpolicyagent/gatekeeper"
    }

    podLabels = {
      "tags.datadoghq.com/env"     = module.core_helpers.environment
      "tags.datadoghq.com/service" = "gatekeeper"
      "tags.datadoghq.com/version" = var.gatekeeper_version
    }

    postInstall = {
      labelNamespace = {
        image = {
          repository = "${var.artifact_registry}/openpolicyagent/gatekeeper-crds"
          tag        = var.gatekeeper_version
        }
      }
    }

    preInstall = {
      crdRepository = {
        image = {
          tag = var.gatekeeper_version
        }
      }
    }

    replicas = var.replicas
  }
}
