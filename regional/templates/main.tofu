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
          rego   = file("${path.module}/k8sblockingress/k8sblockingress.rego")
          target = "admission.k8s.gatekeeper.sh"
        }
      ]
    }
  }
}
