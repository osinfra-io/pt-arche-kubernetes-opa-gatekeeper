# Kubernetes Manifest Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/manifest

resource "kubernetes_manifest" "block_ingress_constraint" {
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
