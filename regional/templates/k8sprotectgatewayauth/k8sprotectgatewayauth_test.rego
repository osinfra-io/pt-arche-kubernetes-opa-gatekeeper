package k8sprotectgatewayauth_test

import data.k8sprotectgatewayauth

parameters := {
	"allowedGroups": ["platform-admins"],
	"allowedUsers": ["platform-deployer@example.iam.gserviceaccount.com"],
	"protectedKinds": [
		{"apiGroup": "networking.istio.io", "kind": "EnvoyFilter"},
		{"apiGroup": "security.istio.io", "kind": "AuthorizationPolicy"},
	],
	"protectedNamespaces": ["identity"],
}

test_protected_kind_denied if {
	some result in k8sprotectgatewayauth.violation with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "security.istio.io", "kind": "AuthorizationPolicy"},
			"object": {"metadata": {"name": "deny-all"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
	result.msg == "gateway authn/authz resource security.istio.io/AuthorizationPolicy is platform-managed and may only be changed by platform principals"
}

test_allowed_group if {
	count(k8sprotectgatewayauth.violation) == 0 with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "security.istio.io", "kind": "AuthorizationPolicy"},
			"object": {"metadata": {"name": "deny-all"}},
			"userInfo": {"groups": ["platform-admins"], "username": "developer@example.com"},
		},
	}
}

test_allowed_user if {
	count(k8sprotectgatewayauth.violation) == 0 with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "networking.istio.io", "kind": "EnvoyFilter"},
			"object": {"metadata": {"name": "gateway-auth"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "platform-deployer@example.iam.gserviceaccount.com"},
		},
	}
}

test_protected_namespace_denied if {
	some result in k8sprotectgatewayauth.violation with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "", "kind": "Namespace"},
			"object": {"metadata": {"name": "identity"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
	result.msg == "namespace \"identity\" is platform-managed and may only be changed by platform principals"
}

test_protected_namespace_delete_denied if {
	some result in k8sprotectgatewayauth.violation with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "", "kind": "Namespace"},
			"object": null,
			"oldObject": {"metadata": {"name": "identity"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
	result.msg == "namespace \"identity\" is platform-managed and may only be changed by platform principals"
}

test_protected_secret_denied if {
	some result in k8sprotectgatewayauth.violation with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "", "kind": "Secret"},
			"object": {"metadata": {"name": "oidc", "namespace": "identity"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
	result.msg == "secrets in platform-managed namespace \"identity\" may only be changed by platform principals"
}

test_protected_secret_delete_denied if {
	some result in k8sprotectgatewayauth.violation with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "", "kind": "Secret"},
			"object": null,
			"oldObject": {"metadata": {"name": "oidc", "namespace": "identity"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
	result.msg == "secrets in platform-managed namespace \"identity\" may only be changed by platform principals"
}

test_unprotected_kind_allowed if {
	count(k8sprotectgatewayauth.violation) == 0 with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "apps", "kind": "Deployment"},
			"object": {"metadata": {"name": "web", "namespace": "team-a"}},
			"userInfo": {"groups": ["system:authenticated"], "username": "developer@example.com"},
		},
	}
}

test_audit_review_without_user_info_allowed if {
	count(k8sprotectgatewayauth.violation) == 0 with input as {
		"parameters": parameters,
		"review": {
			"kind": {"group": "security.istio.io", "kind": "AuthorizationPolicy"},
			"object": {"metadata": {"name": "deny-all"}},
		},
	}
}
