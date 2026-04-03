# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "artifact_registry" {
  description = "The registry to pull the images from"
  type        = string
  default     = "us-docker.pkg.dev/plt-lz-services-tf79-prod/plt-docker-virtual"
}

variable "audit_resources_limits_cpu" {
  description = "The CPU limit for the audit container"
  type        = string
  default     = "40m"

  validation {
    condition     = can(regex("^([0-9]*\\.?[0-9]+)(m)?$", var.audit_resources_limits_cpu))
    error_message = "The audit_resources_limits_cpu value must be a valid Kubernetes CPU quantity (e.g., '40m', '0.1', '1')."
  }
}

variable "audit_resources_limits_memory" {
  description = "The memory limit for the audit container"
  type        = string
  default     = "128Mi"

  validation {
    condition     = can(regex("^([0-9]*\\.?[0-9]+)(Ei|Pi|Ti|Gi|Mi|Ki|E|P|T|G|M|K)?$", var.audit_resources_limits_memory))
    error_message = "The audit_resources_limits_memory value must be a valid Kubernetes memory quantity (e.g., '128Mi', '1Gi', '512M')."
  }
}

variable "audit_resources_requests_cpu" {
  description = "The CPU request for the audit container"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^([0-9]*\\.?[0-9]+)(m)?$", var.audit_resources_requests_cpu))
    error_message = "The audit_resources_requests_cpu value must be a valid Kubernetes CPU quantity (e.g., '10m', '0.1', '1')."
  }
}

variable "audit_resources_requests_memory" {
  description = "The memory request for the audit container"
  type        = string
  default     = "32Mi"

  validation {
    condition     = can(regex("^([0-9]*\\.?[0-9]+)(Ei|Pi|Ti|Gi|Mi|Ki|E|P|T|G|M|K)?$", var.audit_resources_requests_memory))
    error_message = "The audit_resources_requests_memory value must be a valid Kubernetes memory quantity (e.g., '32Mi', '1Gi', '256M')."
  }
}

variable "chart_repository" {
  description = "The repository to pull the Helm chart from"
  type        = string
  default     = "https://open-policy-agent.github.io/gatekeeper/charts"
}

variable "controller_manager_resources_limits_cpu" {
  description = "The CPU limit for the controller manager container"
  type        = string
  default     = "100m"
}

variable "controller_manager_resources_limits_memory" {
  description = "The memory limit for the controller manager container"
  type        = string
  default     = "256Mi"
}

variable "controller_manager_resources_requests_cpu" {
  description = "The CPU request for the controller manager container"
  type        = string
  default     = "10m"
}

variable "controller_manager_resources_requests_memory" {
  description = "The memory request for the controller manager container"
  type        = string
  default     = "32Mi"
}

variable "gatekeeper_version" {
  description = "The version to install, this is used for the chart as well as the image tag"
  type        = string
  default     = "v3.22.0"
}

variable "node_location" {
  description = "The zone in which the cluster's nodes should be located. If not specified, the cluster's nodes are located across zones in the region"
  type        = string
  default     = null
}

variable "replicas" {
  description = "The number of replicas to run"
  type        = number
  default     = 1
}
