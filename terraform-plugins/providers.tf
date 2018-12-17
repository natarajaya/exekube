# This is the list of Terraform plugins to be installed in the exekube container

provider "google" {
  version = "~> 1.20.0"
}

provider "google-beta" {
  version = "~> 1.20.0"
}

provider "random" {
  version = "~> 2.0.0"
}

provider "null" {
  version = "~> 1.0.0"
}

provider "kubernetes" {
  version = "~> 1.4.0"
}

provider "template" {
  version = "~> 1.0.0"
}

provider "tls" {
  version = "~> 1.2.0"
}

provider "local" {
  version = "~> 1.1.0"
}

provider "external" {
  version = "~> 1.0.0"
}

provider "aws" {
  version = "~> 1.52.0"
}
