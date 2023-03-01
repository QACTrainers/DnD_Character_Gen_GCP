resource "google_sql_database_instance" "project-db" {
    name = "project server"
    database_version = "MYSQL_8_0"

    settings {
        tier = "db-f1-micro"

        ip_configuration {
            dynamic "authorized_networks" {
                content {
                  name = "all_networks"
                  content = "0.0.0.0/0"
                }
            }
        }
    }
}

resource "google_sql_database" "project" {
    name = "project-db"
    instance = google_sql_database_instance.project-db.name
}