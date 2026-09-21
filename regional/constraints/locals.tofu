# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  protect_gateway_auth_match_kinds = concat(
    [
      {
        apiGroups = [""]
        kinds     = ["Namespace", "Secret"]
      },
    ],
    [
      for protected_kind in var.protected_kinds : {
        apiGroups = [protected_kind.apiGroup]
        kinds     = [protected_kind.kind]
      }
    ],
  )

  protect_gateway_auth_parameters = {
    allowedGroups       = var.allowed_groups
    allowedUsers        = var.allowed_users
    protectedKinds      = var.protected_kinds
    protectedNamespaces = var.protected_namespaces
  }
}
