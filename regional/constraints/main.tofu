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

resource "kubernetes_manifest" "protect_gateway_auth_constraint" {
  manifest = {
    apiVersion = "constraints.gatekeeper.sh/v1beta1"
    kind       = "K8sProtectGatewayAuth"

    metadata = {
      name = "protect-gateway-auth"
    }

    spec = {
      enforcementAction = "deny"

      match = {
        kinds = local.protect_gateway_auth_match_kinds
      }

      parameters = local.protect_gateway_auth_parameters
    }
  }
}
