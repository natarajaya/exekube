# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "Project where resources will be created"
}

variable "serviceaccount_key" {
  description = "Service account key for the project"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "network_name" {
  default = "network"
}

variable "main_compute_zone" {
  description = "Master zone (only one of region and main_compute_zone may be set)"
  default     = ""
}

variable "region" {
  description = "Cluster region (only one of region and main_compute_zone may be set)"
  default     = ""
}

variable "additional_zones" {
  description = "Specify zones in which to spin up worker nodes (only if region is not set)"
  default     = []
}

variable "enable_kubernetes_alpha" {
  default = false
}

variable "enable_binary_authorization" {
  default = false
}

variable "binary_authorization_evaluation_mode" {
  default = "ALWAYS_ALLOW"
}

variable "binary_authorization_enforcement_mode" {
  default = "ENFORCED_BLOCK_AND_AUDIT_LOG"
}

variable "binary_authorization_admission_whitelist_pattern_0" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_1" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_2" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_3" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_4" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_5" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_6" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "binary_authorization_admission_whitelist_pattern_7" {
  # This value cannot be empty, so use a placeholder value that satisfies Google's API.
  default = "PLACE.HOLDER/PATTERN"
}

variable "initial_node_count" {
  default = 1
}

variable "kubernetes_version" {
  default = "1.12.7-gke.7"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com"
}

variable "logging_service" {
  default = "logging.googleapis.com"
}

variable "dashboard_disabled" {
  default     = false
  description = "Disable Kubernetes Dashboard"
}

variable "http_load_balancing_disabled" {
  default     = false
  description = "Disable GKE HTTP (L7) load balancing controller addon"
}

variable "master_auth_username" {
  default     = ""
  description = "The username to use for HTTP basic authentication (setting both password and username to empty strings disables legacy basic authentication)"
}

variable "master_auth_password" {
  default     = ""
  description = "The password to use for HTTP basic authentication (setting both password and username to empty strings disables legacy basic authentication)"
}

variable "issue_client_certificate" {
  default     = true
  description = "Whether client certificate authorization is enabled"
}

variable "create_timeout" {
  default = "30m"
}

variable "update_timeout" {
  default = "10m"
}

variable "delete_timeout" {
  default = "10m"
}

variable "istio_disabled" {
  default     = true
  description = "Disable Istio add-on"
}

variable "istio_auth" {
  default     = "AUTH_MUTUAL_TLS"
  description = "Set auth mechanism for Istio add-on"
}

variable "primary_pool_min_node_count" {
  default     = 1
  description = "Primary Node pool Min node count"
}

variable "primary_pool_max_node_count" {
  default     = 1
  description = "Primary Node pool Max node count"
}

variable "primary_pool_initial_node_count" {
  default     = 1
  description = "Primary Node pool Initial node count"
}

variable "primary_pool_auto_repair" {
  default     = true
  description = "Primary Node pool Auto repair enabled"
}

variable "primary_pool_auto_upgrade" {
  default     = true
  description = "Primary Node pool Auto upgrade enabled"
}

variable "primary_pool_disk_size_gb" {
  default     = 200
  description = "Primary Node pool Disk size in GB"
}

variable "primary_pool_disk_type" {
  default     = "pd-standard"
  description = "Primary Node pool Disk type"
}

variable "primary_pool_machine_type" {
  default     = "n1-standard-2"
  description = "Primary Node pool Machine type"
}

variable "primary_pool_image_type" {
  default     = "COS"
  description = "Primary Node pool Image type"
}

variable "primary_pool_oauth_scopes" {
  default     = ["gke-default"]
  description = "Primary Node pool OAuth scopes"
}

variable "primary_pool_service_account" {
  default     = ""
  description = "Primary Node pool Service account"
}

variable "node_pool_create_timeout" {
  default     = "30m"
  description = "Node pool Create timeout"
}

variable "node_pool_update_timeout" {
  default     = "30m"
  description = "Node pool Update timeout"
}

variable "node_pool_delete_timeout" {
  default     = "30m"
  description = "Node pool Delete timeout"
}
