package k8sblockingress

violation contains {"msg": msg} if {
	input.review.object.kind == "Ingress"
	ingress_name := input.review.object.metadata.name
	msg := sprintf("Ingress resources are not allowed. Use Istio Gateway instead. Ingress: %v", [ingress_name])
}
