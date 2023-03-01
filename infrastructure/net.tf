resource "google_compute_network" "demo-net" {
    name = "demo-net"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo-subnet" {
    name = "demo-subnet"
    ip_cidr_range = "10.0.0.0/24"
    network = google_compute_network.demo-net.id
}

resource "google_compute_firewall" "demo-fw" {
    name = "test-fw"
    network = google_compute_network.demo-net.name
    source_ranges = ["0.0.0.0/0"]

    allow {
      protocol = "tcp"
      ports = ["22", "8080"]
    }
}