package k8sblockingress

violation[{"msg": msg}] {
  input.review.object.kind == "Ingress"
  msg := sprintf("Ingress resources are not allowed. Use Istio Gateway instead. Ingress: %v", [input.review.object.metadata.name])
}
