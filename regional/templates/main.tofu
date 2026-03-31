# Kubernetes Manifest Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/manifest

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
          rego = <<-REGO
            package k8sblockingress

            violation[{"msg": msg}] {
              input.review.object.kind == "Ingress"
              msg := sprintf("Ingress resources are not allowed. Use Istio Gateway instead. Ingress: %v", [input.review.object.metadata.name])
            }
          REGO

          target = "admission.k8s.gatekeeper.sh"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "team_constraint_templates" {
  for_each = var.gatekeeper_constraints

  manifest = each.value.template
}
