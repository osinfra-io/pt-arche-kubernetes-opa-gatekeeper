package k8sblockingress_test

# regal ignore:use-rego-v1,use-if

import data.k8sblockingress

test_ingress_denied {
	some result in k8sblockingress.violation with input as {"review": {"object": {
		"kind": "Ingress",
		"metadata": {"name": "my-ingress"},
	}}}
	result.msg == "Ingress resources are not allowed. Use Istio Gateway instead. Ingress: my-ingress"
}
