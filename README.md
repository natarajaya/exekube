> ⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

# Exekube

You can define Ruby on Rails as a framework for building web apps. Exekube is a framework for **deploying any workload or storage resource to a cloud** (like Google Cloud, AWS, or Azure). Exekube is a thin automation layer on top of modern open-source tools like Docker, Kubernetes, and HashiCorp Terraform.

We can also define Exekube as an experimental declarative framework for administering and using Kubernetes clusters.

The ultimate goal of this project is to be able to control your cloud infrastructure and all Kubernetes objects using nothing more than a git-managed codebase (git repository) with a Continuous Delivery pipeline.

📘 Read the companion guide: <https://github.com/ilyasotkov/learning-kubernetes/>

- [Introduction](#introduction)
	- [Principles](#principles)
	- [Technology stack](#technology-stack)
- [Set up local development environment](#set-up-local-containerized-tools)
	- [Requirements starting from zero](#requirements-starting-from-zero)
	- [Local setup step-by-step](#local-setup-step-by-step)
- [Core feature tracker](#core-feature-tracker)
	- [Preparation](#preparation)
	- [Cloud provider config](#cloud-provider-config)
	- [Cluster creation](#cluster-creation)
	- [Cluster access control](#cluster-access-control)
	- [Supporting tools](#supporting-tools)
	- [User apps and services](#user-apps-and-services)
- [Known issues](#known-issues)

## Introduction

### Principles

- [x] Everything on client side is dockerized and contained in repo root directory
- [x] Everything is expressed as declarative code, using Terraform and HCL (HashiCorp Language)
- [ ] Git-based workflow (no GUI or CLI) with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven (TDD) or behavior-driven (BDD) model of development

### Technology stack

⚠️ Most CLI and GUI tools will be eventually deprecated in favor of a declarative tool, most likely [Terraform](/)

#### Docker local environment

- Docker container runtime
- Docker Compose declarative client

#### Cloud provider client (only Google Cloud Platform for now)

- Imperative CLI client: `gcloud`
- Imperative GUI client: [GCP Console](/)
- ‍Declarative code client: [terraform-provider-google](/) (support for AWS and Azure in the future?)

#### Kubernetes client (Kubernetes workload, storage, networking objects)

- Imperative CLI client: `kubectl`
- Declarative code client: [terraform-kubernetes-provider](/)

#### Helm client (Repositories, Charts, Releases)

- Imperative CLI client: `helm`
- Declarative code client: [terraform-helm-provider](/)

## Setup and Usage

### Requirements starting from zero

Everything on your workstation runs in a container using Docker Compose.

The only requirements, depending on your local OS:

#### Linux

- [Docker](/)
- [Docker Compose](/)

#### macOS

- [Docker for Mac](/)

#### Windows

- [Docker for Windows](/)

### Local setup step-by-step

0. ⬇️ Create `xk` alias in shell session:
    ```bash
    alias xk="docker-compose run --rm exekube"
    ```
1. [Set up](https://console.cloud.google.com/) a Google Account for CGP (Google Cloud Platform), create a project named "ethereal-argon-186217", enable billing.
2. [Create](/) a service account in GCP Console GUI, give it project owner permissions.
3. [Download](/) `.json` credentials ("key") to repo root directory and rename the file to `credentials.json`.
4. ⬇️ Use `.json` credentials to activate service account:
    ```sh
    xk gcloud auth activate-service-account --key-file credentials.json
    ```
5. ⬇️ Create a Google Cloud Storage bucket (with versioning) for Terraform remote state:
    ```sh
    xk gsutil mb -p ethereal-argon-186217 gs://ethereal-argon-terraform-state \
        && xk gsutil versioning set on gs://ethereal-argon-terraform-state
    ```
6. ⬇️ Initialize terraform:
    ```sh
    xk terraform init live/gcp-ethereal-argon
    ```

### Usage / workflow

#### Imperative (CLI) Exekube toolset

- `xk gcloud`
- `xk kubectl`
- `xk helm`

```sh
# This is an example of how you can deploy an static nginx webpage and a rails application to the cluster

xk helm install --name ingress-controller \
        -f helm/releases/nginx-ingress.yaml \
        helm/charts/kube-lego/

xk helm install --name letsencrypt-controller \
        helm/charts/kube-lego/

xk helm install --name my-nginx-page \
        -f helm/releases/nginx-webpage-devel.yaml \
        helm/charts/nginx-webpage/

xk helm install --name my-rails-app \
        -f helm/releases/rails-app-devel.yaml \
        helm/charts/rails-app/
```

#### Declarative Exekube toolset

- `xk terraform`

Declarative tools are exact equivalents of using the imperative (CLI) toolset, except everything is implemented as a Terraform provider plugin. Instead of writing script that use `xk helm install --name <release-name> -f <values> <chart>` commands to deploy workloads to the cloud, we use `xk terraform apply`.

## Core feature tracker

Features are marked with ✔️ when they enter the alpha stage, meaning there's a declarative (except for the Preparation step) *proof-of-concept* solution implemented

### Preparation

- [x] Create GCP account, enable billing in GCP Console (web GUI)
- [x] Get credentials for GCP (`credentials.json`)
- [x] Authenticate to GCP using `credentials.json` (for `gcloud` and `terraform` use)
- [x] Enable terraform remote state in a Cloud Storage bucket

### Cloud provider config

- [ ] Create GCP Folders and Projects and associated policies
- [x] Create GCP IAM Service Accounts and IAM Policies for the Project

### Cluster creation

- [x] Create the GKE cluster
- [x] Get cluster credentials (`/root/.kube/config` file)
- [x] Initialize Helm

### Cluster access control

- [x] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

### Supporting tools

- [x] Install cluster ingress controller (cloud load balancer)
- [ ] Install TLS certificates controller (kube-lego)
- [ ] Install monitoring tools (Prometheus, Grafana)
- [ ] Install continuous integration tools (Gitlab / Gogs, Jenkins / Drone)

### User apps and services

- [ ] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.

## Known issues

- [ ] If IAM API is not enabled, trying to enable it via Terraform and then creating a service account will not work since enabling an API might take longer
- [x] A LoadBalancer created via installing an ingress controller chart will not be destroyed when we run `terraform destroy`
- [ ] https://github.com/ilyasotkov/exekube/issues/4
