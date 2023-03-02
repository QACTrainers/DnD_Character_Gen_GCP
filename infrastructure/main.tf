terraform {
    required_providers {
      google = {
        source  = "hashicorp/google"
        version = "4.27.0"
      }
    }
}

provider "google" {
    project     = "lbg-cloud-incubation"
    region      = "europe-west2"
    zone        = "europe-west2-c"
    scopes      = ["https://www.googleapis.com/auth/cloud-platform"]
}

