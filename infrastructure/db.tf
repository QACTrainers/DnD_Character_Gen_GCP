resource "google_sql_database_instance" "project-db" {
    name = "project-server"
    database_version = "MYSQL_8_0"

    settings {
        tier = "db-f1-micro"

        ip_configuration {
            ipv4_enabled = true
             authorized_networks {
                  name = "all_networks"
                  value = "0.0.0.0/0"
            }
        }
    }
}

resource "google_sql_database" "project" {
    name = "project-db"
    instance = google_sql_database_instance.project-db.name
}