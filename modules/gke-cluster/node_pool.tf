resource "google_container_node_pool" "primary" {
  provider = "google-beta"
  count    = "${var.region == "" ? 1 : 0}"

  project = "${var.project_id}"
  cluster = "${google_container_cluster.cluster.name}"
  zone    = "${var.main_compute_zone}"

  autoscaling {
    min_node_count = "${var.primary_pool_min_node_count}"
    max_node_count = "${var.primary_pool_max_node_count}"
  }

  initial_node_count = "${var.primary_pool_initial_node_count}"

  management {
    auto_repair  = "${var.primary_pool_auto_repair}"
    auto_upgrade = "${var.primary_pool_auto_upgrade}"
  }

  node_config {
    disk_size_gb    = "${var.primary_pool_disk_size_gb}"
    disk_type       = "${var.primary_pool_disk_type}"
    machine_type    = "${var.primary_pool_machine_type}"
    image_type      = "${var.primary_pool_image_type}"
    oauth_scopes    = "${var.primary_pool_oauth_scopes}"
    service_account = "${var.primary_pool_service_account != "" ? var.primary_pool_service_account : data.google_compute_default_service_account.default.email }"

    labels {
      project = "${var.project_id}"
      cluster = "${google_container_cluster.cluster.name}"
      pool    = "primary"
    }

    workload_metadata_config {
      node_metadata = "SECURE"
    }

    metadata = {
      disable-legacy-endpoints = "false"
    }
  }

  timeouts {
    create = "${var.node_pool_create_timeout}"
    update = "${var.node_pool_update_timeout}"
    delete = "${var.node_pool_delete_timeout}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_container_node_pool" "primary-regional" {
  provider = "google-beta"
  count    = "${var.region == "" ? 0 : 1}"

  project = "${var.project_id}"
  cluster = "${google_container_cluster.cluster-regional.name}"
  region  = "${var.region}"

  autoscaling {
    min_node_count = "${var.primary_pool_min_node_count}"
    max_node_count = "${var.primary_pool_max_node_count}"
  }

  initial_node_count = "${var.primary_pool_initial_node_count}"

  management {
    auto_repair  = "${var.primary_pool_auto_repair}"
    auto_upgrade = "${var.primary_pool_auto_upgrade}"
  }

  node_config {
    disk_size_gb    = "${var.primary_pool_disk_size_gb}"
    disk_type       = "${var.primary_pool_disk_type}"
    machine_type    = "${var.primary_pool_machine_type}"
    image_type      = "${var.primary_pool_image_type}"
    oauth_scopes    = "${var.primary_pool_oauth_scopes}"
    service_account = "${var.primary_pool_service_account != "" ? var.primary_pool_service_account : data.google_compute_default_service_account.default.email }"

    labels {
      project = "${var.project_id}"
      cluster = "${google_container_cluster.cluster-regional.name}"
      pool    = "primary"
    }

    workload_metadata_config {
      node_metadata = "SECURE"
    }

    metadata = {
      disable-legacy-endpoints = "false"
    }
  }

  timeouts {
    create = "${var.node_pool_create_timeout}"
    update = "${var.node_pool_update_timeout}"
    delete = "${var.node_pool_delete_timeout}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
