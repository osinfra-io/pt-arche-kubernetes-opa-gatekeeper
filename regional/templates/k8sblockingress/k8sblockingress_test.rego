package k8sblockingress_test

import data.k8sblockingress

test_ingress_denied if {
	some result in k8sblockingress.violation with input as {"review": {"object": {
		"kind": "Ingress",
		"metadata": {"name": "my-ingress"},
	}}}
	result.msg == "Ingress resources are not allowed. Use Istio Gateway instead. Ingress: my-ingress"
}
