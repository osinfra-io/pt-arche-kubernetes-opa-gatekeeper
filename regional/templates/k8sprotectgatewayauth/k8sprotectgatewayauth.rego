package k8sprotectgatewayauth

allowed_principal if {
	input.review.userInfo.username in object.get(input.parameters, "allowedUsers", [])
}

allowed_principal if {
	group := input.review.userInfo.groups[_]
	group in object.get(input.parameters, "allowedGroups", [])
}

# Gatekeeper audit reviews carry no userInfo (there is no requesting actor), so the identity of the
# change cannot be evaluated. Treat those reviews as allowed to avoid reporting every pre-existing
# protected resource as a false-positive violation; admission requests always populate userInfo.
allowed_principal if {
	not input.review.userInfo
}

protected_kind if {
	configured_kind := object.get(input.parameters, "protectedKinds", [])[_]
	input.review.kind.group == configured_kind.apiGroup
	input.review.kind.kind == configured_kind.kind
}

protected_namespace if {
	input.review.kind.group == ""
	input.review.kind.kind == "Namespace"
	review_object.metadata.name in object.get(input.parameters, "protectedNamespaces", [])
}

protected_secret if {
	input.review.kind.group == ""
	input.review.kind.kind == "Secret"
	object.get(review_object.metadata, "namespace", "") in object.get(input.parameters, "protectedNamespaces", [])
}

review_object := object.get(input.review, "object", null) if {
	object.get(input.review, "object", null) != null
}

review_object := object.get(input.review, "oldObject", {}) if {
	object.get(input.review, "object", null) == null
}

violation contains {"msg": msg} if {
	not allowed_principal
	protected_kind
	msg := sprintf("gateway authn/authz resource %s/%s is platform-managed and may only be changed by platform principals", [input.review.kind.group, input.review.kind.kind])
}

violation contains {"msg": msg} if {
	not allowed_principal
	protected_namespace
	msg := sprintf("namespace %q is platform-managed and may only be changed by platform principals", [review_object.metadata.name])
}

violation contains {"msg": msg} if {
	not allowed_principal
	protected_secret
	msg := sprintf("secrets in platform-managed namespace %q may only be changed by platform principals", [object.get(review_object.metadata, "namespace", "")])
}
