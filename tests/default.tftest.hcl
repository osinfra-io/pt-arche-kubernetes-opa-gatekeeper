# Test
# https://opentofu.org/docs/cli/commands/test

# Mock Providers
# https://opentofu.org/docs/cli/commands/test/#the-mock_provider-blocks

mock_provider "google" {}
mock_provider "helm" {}
mock_provider "kubernetes" {}
mock_provider "terraform" {}

run "default_regional" {
  command = apply

  module {
    source = "./tests/fixtures/default/regional"
  }
}

run "gatekeeper_log_source" {
  command = plan

  module {
    source = "./regional"
  }

  override_module {
    target = module.core_helpers
    outputs = {
      env         = "prod"
      environment = "production"
      region      = "us-east1"
      zone        = "b"
    }
  }

  variables {
    artifact_registry = "mock-docker.pkg.dev/mock-project/mock-virtual"
  }

  assert {
    condition     = jsondecode(yamldecode(helm_release.gatekeeper.values[0]).podAnnotations["ad.datadoghq.com/manager.logs"])[0].source == "gatekeeper"
    error_message = "Gatekeeper manager logs must use the gatekeeper source."
  }

  assert {
    condition = (
      yamldecode(helm_release.gatekeeper.values[1]).podLabels == {
        "tags.datadoghq.com/env"     = "production"
        "tags.datadoghq.com/service" = "gatekeeper"
        "tags.datadoghq.com/version" = var.gatekeeper_version
      } &&
      yamldecode(helm_release.gatekeeper.values[1]).audit.podLabels["tags.datadoghq.com/manager.service"] == "gatekeeper-audit" &&
      yamldecode(helm_release.gatekeeper.values[1]).controllerManager.podLabels["tags.datadoghq.com/manager.service"] == "gatekeeper-controller-manager"
    )
    error_message = "Gatekeeper must consolidate unified tags while retaining distinct audit/controller container services without duplicating the shared service label."
  }
}

run "default_regional_templates" {
  command = apply

  module {
    source = "./tests/fixtures/default/regional/templates"
  }
}

run "default_regional_constraints" {
  command = apply

  module {
    source = "./tests/fixtures/default/regional/constraints"
  }
}
