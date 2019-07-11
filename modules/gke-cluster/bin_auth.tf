resource "google_binary_authorization_policy" "policy" {
  count    = "${var.enable_binary_authorization ? 1 : 0}"
  provider = "google-beta"
  project  = "${var.project_id}"

  default_admission_rule {
    evaluation_mode  = "${var.binary_authorization_evaluation_mode}"
    enforcement_mode = "${var.binary_authorization_enforcement_mode}"
  }

  admission_whitelist_patterns {
    name_pattern = "${var.binary_authorization_admission_whitelist_patterns}"
  }
}
