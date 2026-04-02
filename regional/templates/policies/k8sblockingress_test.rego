package k8sblockingress_test

import data.k8sblockingress

test_ingress_denied {
  result := k8sblockingress.violation[_] with input as {
    "review": {
      "object": {
        "kind": "Ingress",
        "metadata": {"name": "my-ingress"}
      }
    }
  }
  result.msg == "Ingress resources are not allowed. Use Istio Gateway instead. Ingress: my-ingress"
}

test_deployment_allowed {
  count(k8sblockingress.violation) == 0 with input as {
    "review": {
      "object": {
        "kind": "Deployment",
        "metadata": {"name": "my-deployment"}
      }
    }
  }
}
