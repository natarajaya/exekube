variable "secrets_dir" {}

# This module will generate TLS assets that may later be used
# To secure Tiller installation by helm-initializer module with TLS authentication.
# By default, TLS assets will be generated to a following directory:
# ${secrets_dir}/${custom_tls_dir:-tiller-namespace}/${helm_dir_name}

variable "custom_tls_dir" {
  default = ""
}

variable "helm_dir_name" {
  default = "helm-tls"
}

variable "tiller_namespace" {
  default = "kube-system"
}
