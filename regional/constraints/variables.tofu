# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "allowed_groups" {
  description = "Kubernetes groups permitted to manage protected gateway authentication resources"
  type        = list(string)
  default     = ["system:masters"]
}

variable "allowed_users" {
  description = "Kubernetes usernames permitted to manage protected gateway authentication resources"
  type        = list(string)
  default     = []
}

variable "protected_kinds" {
  description = "Kubernetes resource kinds that only allowed users and groups may manage"

  type = list(object({
    apiGroup = string
    kind     = string
  }))

  default = [
    {
      apiGroup = "networking.istio.io"
      kind     = "EnvoyFilter"
    },
    {
      apiGroup = "security.istio.io"
      kind     = "AuthorizationPolicy"
    },
    {
      apiGroup = "security.istio.io"
      kind     = "RequestAuthentication"
    },
  ]

  validation {
    condition     = alltrue([for protected_kind in var.protected_kinds : trimspace(protected_kind.kind) != ""])
    error_message = "Each protected_kinds entry must have a non-empty kind."
  }
}

variable "protected_namespaces" {
  description = "Kubernetes namespaces whose lifecycle and Secrets only allowed users and groups may manage"
  type        = list(string)
  default     = ["authentik"]

  validation {
    condition     = alltrue([for namespace in var.protected_namespaces : trimspace(namespace) != ""])
    error_message = "protected_namespaces entries must not be empty."
  }
}
