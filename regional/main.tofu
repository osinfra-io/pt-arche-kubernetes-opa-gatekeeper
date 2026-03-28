# Helm Release
# https://search.opentofu.org/provider/hashicorp/helm/latest/docs/resources/release

resource "helm_release" "gatekeeper" {
  depends_on = [
    kubernetes_manifest.opa_gatekeeper_selfsigned_issuer
  ]

  chart      = "gatekeeper"
  name       = "gatekeeper"
  namespace  = "gatekeeper-system"
  repository = var.chart_repository
  set        = local.helm_values

  values = [
    file("${path.module}/helm/gatekeeper.yml")
  ]

  version = var.gatekeeper_version
}

# Kubernetes Manifest Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/manifest

resource "kubernetes_manifest" "opa_gatekeeper_ca_certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      labels = {
        "gatekeeper.sh/system" = "yes"
      }

      name      = "gatekeeper-ca"
      namespace = "gatekeeper-system"
    }

    spec = {
      commonName = "gatekeeper-ca.osinfra.io"
      duration   = "2160h"
      isCA       = true

      issuerRef = {
        name  = kubernetes_manifest.opa_gatekeeper_selfsigned_issuer.manifest.metadata.name
        kind  = "Issuer"
        group = "cert-manager.io"
      }

      secretName = "gatekeeper-ca"

      subject = {
        organizations = ["gatekeeper.osinfra.io"]
      }
    }
  }
}

resource "kubernetes_manifest" "opa_gatekeeper_ca_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"

    metadata = {
      labels = {
        "gatekeeper.sh/system" = "yes"
      }

      name      = "gatekeeper-ca"
      namespace = "gatekeeper-system"
    }

    spec = {
      ca = {
        secretName = kubernetes_manifest.opa_gatekeeper_ca_certificate.manifest.metadata.name
      }
    }
  }
}

resource "kubernetes_manifest" "opa_gatekeeper_selfsigned_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"

    metadata = {
      labels = {
        "gatekeeper.sh/system" = "yes"
      }

      name      = "selfsigned"
      namespace = "gatekeeper-system"
    }

    spec = {
      selfSigned = {}
    }
  }
}

resource "kubernetes_manifest" "opa_gatekeeper_server_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      labels = {
        "gatekeeper.sh/system" = "yes"
      }

      name      = "gatekeeper-webhook-server-cert"
      namespace = "gatekeeper-system"
    }

    spec = {
      commonName = "gatekeeper-webhook-service.osinfra.io"

      dnsNames = [
        "gatekeeper-webhook-service",
        "gatekeeper-webhook-service.gatekeeper-system",
        "gatekeeper-webhook-service.gatekeeper-system.svc"
      ]

      duration = "2160h"
      isCA     = false

      issuerRef = {
        name  = kubernetes_manifest.opa_gatekeeper_ca_issuer.manifest.metadata.name
        kind  = "Issuer"
        group = "cert-manager.io"
      }

      renewBefore = "360h"
      secretName  = "gatekeeper-webhook-server-cert"

      usages = [
        "server auth"
      ]
    }
  }
}
