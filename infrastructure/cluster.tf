resource "google_container_cluster" "gke-tf-demo" {
    name = "demo-gke-cluster"
    remove_default_node_pool = true
    initial_node_count = 1
}

resource "google_container_node_pool" "demo-nodes" {
    name = "demo-nodes"
    cluster = google_container_cluster.gke-tf-demo.id

    autoscaling {
        min_node_count = 1
        max_node_count = 4
    }

    node_config {
        disk_size_gb = 10
        machine_type = "e2-small"
        image_type = "COS_CONTAINERD"
        oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }
}