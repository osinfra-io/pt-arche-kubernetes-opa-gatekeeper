# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "gatekeeper_constraints" {
  default     = {}
  description = "Team-supplied OPA Gatekeeper ConstraintTemplate and Constraint pairs to deploy alongside platform-managed policies"
  type        = map(object({ constraint = any, template = any }))
}
