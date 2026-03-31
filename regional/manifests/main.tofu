# Kubernetes Manifest Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/manifest

resource "kubernetes_manifest" "block_ingress_constraint" {
  depends_on = [kubernetes_manifest.block_ingress_constraint_template]

  manifest = {
    apiVersion = "constraints.gatekeeper.sh/v1beta1"
    kind       = "K8sBlockIngress"

    metadata = {
      name = "block-ingress"
    }

    spec = {
      enforcementAction = "deny"

      match = {
        excludedNamespaces = ["istio-ingress"]

        kinds = [
          {
            apiGroups = ["networking.k8s.io"]
            kinds     = ["Ingress"]
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "block_ingress_constraint_template" {
  manifest = {
    apiVersion = "templates.gatekeeper.sh/v1"
    kind       = "ConstraintTemplate"

    metadata = {
      name = "k8sblockingress"
    }

    spec = {
      crd = {
        spec = {
          names = {
            kind = "K8sBlockIngress"
          }
        }
      }

      targets = [
        {
          rego   = "package k8sblockingress\n\nviolation[{\"msg\": msg}] {\n  input.review.object.kind == \"Ingress\"\n  msg := sprintf(\"Ingress resources are not allowed. Use Istio Gateway instead. Ingress: %v\", [input.review.object.metadata.name])\n}"
          target = "admission.k8s.gatekeeper.sh"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "team_constraints" {
  for_each = var.gatekeeper_constraints

  depends_on = [kubernetes_manifest.team_constraint_templates]

  manifest = each.value.constraint
}

resource "kubernetes_manifest" "team_constraint_templates" {
  for_each = var.gatekeeper_constraints

  manifest = each.value.template
}
