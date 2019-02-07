# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDERS CONFIG
# ------------------------------------------------------------------------------

terraform {
  backend "gcs" {}
}

provider "local" {}

locals {
  tls_dir       = "${var.secrets_dir}/${var.custom_tls_dir == "" ? var.tiller_namespace : var.custom_tls_dir}/${var.helm_dir_name}"
  rbac_filename = "${var.tiller_namespace == "kube-system" ? "rbac-cluster.yaml" : "rbac-ns.yaml"}"
}

data "template_file" "tiller_rbac" {
  template = "${file("${format("%s/%s", path.module, local.rbac_filename)}")}"

  vars {
    tiller_namespace = "${var.tiller_namespace}"
  }
}

# tiller_status is introduced as a way to to make sure helm is reinstalled if
# the cluster is recreated and/or tiller is broken or not present
#
# This introduces undesired behavior that tiller will be deployed twice,
# as the trigger mechanism is not based on the state, but rather on the change
# of the state. So:
# - 1st run: resource does not exist, the trigger is evaluated to random number
#   -> resource is created
# - 2nd run: resource does exist, but the trigger changed to "1" -> resource
#   is recreated
# - 3rd and subsequent runs: resource does exist, trigger stays "1" -> no
#   changes unless the tiller is deleted or stops working, if that happens
#   the trigger changes and cycle described above will repeat once more

data "external" "tiller_status" {
  program = [
    "bash",
    "-c",
    "REPLICAS=$$(kubectl get deploy tiller-deploy -n ${var.tiller_namespace} -o jsonpath='{.status.readyReplicas}'); [ \"$$REPLICAS\" != \"1\" ] && REPLICAS=\"$$RANDOM\"; jq -n --arg replicas \"$$REPLICAS\" '{readyReplicas:$$replicas}'",
  ]
}

# tiller_version detects when the version of the Helm client is newer.

data "external" "tiller_version" {
  program = [
    "bash",
    "-c",
    "HELM_VERSION_CLIENT=$$(helm version --client --short); jq -n --arg version \"$$HELM_VERSION_CLIENT\" '{tillerClientVersion:$$version}'",
  ]
}

resource "null_resource" "install_tiller" {
  triggers {
    tiller_ready_replicas = "${data.external.tiller_status.result.readyReplicas}"
    tiller_version        = "${data.external.tiller_version.result.tillerClientVersion}"
  }

  provisioner "local-exec" {
    command = <<EOF
      echo '${data.template_file.tiller_rbac.rendered}' | kubectl apply -f - \
      && helm init \
        --upgrade \
        --tiller-namespace ${var.tiller_namespace} \
        --service-account tiller \
        --tiller-tls \
        --tiller-tls-verify \
        --tls-ca-cert=${local.tls_dir}/${var.ca_cert_filename} \
        --tiller-tls-cert=${local.tls_dir}/${var.tiller_cert_filename} \
        --tiller-tls-key=${local.tls_dir}/${var.tiller_key_filename} \
        --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}'
      RETRIES=10
      RETRY_COUNT=1
      TILLER_READY="false"
      while [ "$TILLER_READY" != "true" ]; do
        echo "[Try $RETRY_COUNT of $RETRIES] Waiting for Tiller..."
        helm version \
          --tls --tls-verify \
          --tls-ca-cert=${local.tls_dir}/${var.ca_cert_filename} \
          --tls-cert=${local.tls_dir}/${var.helm_cert_filename} \
          --tls-key=${local.tls_dir}/${var.helm_key_filename} \
          --tiller-connection-timeout ${var.tiller_connection_timeout} > /dev/null 2> /dev/null
        if [ "$?" == "0" ]; then
          TILLER_READY="true"
        fi
        if [ "$RETRY_COUNT" == "$RETRIES" ] && [ "$TILLER_READY" != "true" ]; then
          echo "Retry limit reached, giving up!"
          exit 1
        fi
        if [ "$TILLER_READY" != "true" ]; then
          sleep 10
        fi
        RETRY_COUNT=$(($RETRY_COUNT+1))
      done
      helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com \
      && helm repo update
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
      helm reset --force \
        --tiller-namespace ${var.tiller_namespace} \
        --tls --tls-verify \
        --tls-ca-cert=${local.tls_dir}/${var.ca_cert_filename} \
        --tls-cert=${local.tls_dir}/${var.helm_cert_filename} \
        --tls-key=${local.tls_dir}/${var.helm_key_filename} \
        --tiller-connection-timeout ${var.tiller_connection_timeout}
    EOF
  }
}
