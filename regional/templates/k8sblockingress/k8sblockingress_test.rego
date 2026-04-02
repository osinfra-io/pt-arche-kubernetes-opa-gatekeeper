package k8sblockingress_test

import rego.v1

import data.k8sblockingress

test_ingress_denied if {
	some result in k8sblockingress.violation with input as {"review": {"object": {
		"kind": "Ingress",
		"metadata": {"name": "my-ingress"},
	}}}
	result.msg == "Ingress resources are not allowed. Use Istio Gateway instead. Ingress: my-ingress"
}

test_deployment_allowed if {
	count(k8sblockingress.violation) == 0 with input as {"review": {"object": {
		"kind": "Deployment",
		"metadata": {"name": "my-deployment"},
	}}}
}
