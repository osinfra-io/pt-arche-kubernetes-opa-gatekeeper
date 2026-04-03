package k8sblockingress

# Gatekeeper's embedded OPA does not support import rego.v1; use legacy syntax.
# regal ignore:use-rego-v1,use-contains,use-if

violation[{"msg": msg}] {
	input.review.object.kind == "Ingress"
	ingress_name := input.review.object.metadata.name
	msg := sprintf("Ingress resources are not allowed. Use Istio Gateway instead. Ingress: %v", [ingress_name])
}
