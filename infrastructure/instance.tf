resource "google_compute_instance" "demo" {
    name = "test-vm"
    machine_type = "e2-small"

    boot_disk {
        initialize_params {
            image = "family/ubuntu-2004-lts"
        }
    }

    network_interface {
        subnetwork = google_compute_subnetwork.demo-subnet.id

        access_config {
        // Ephemeral public IP
        }
    }

    metadata_startup_script = <<EOF2
    #!/bin/bash
    if type apt > /dev/null; then
        pkg_mgr=apt
        java="openjdk-11-jre"
    elif type yum /dev/null; then
        pkg_mgr=yum
        java="java"
    fi
    echo "updating and installing dependencies"
    sudo ${pkg_mgr} update
    sudo ${pkg_mgr} install -y ${java} wget git > /dev/null
    echo "configuring jenkins user"
    sudo useradd -m -s /bin/bash jenkins
    echo "downloading latest jenkins WAR"
    sudo su - jenkins -c "curl -L https://updates.jenkins-ci.org/latest/jenkins.war --output jenkins.war"
    echo "setting up jenkins service"
    sudo tee /etc/systemd/system/jenkins.service << EOF > /dev/null
    [Unit]
    Description=Jenkins Server

    [Service]
    User=jenkins
    WorkingDirectory=/home/jenkins
    ExecStart=/usr/bin/java -jar /home/jenkins/jenkins.war

    [Install]
    WantedBy=multi-user.target
    EOF
    sudo systemctl daemon-reload
    sudo systemctl enable jenkins
    sudo systemctl restart jenkins
    sudo su - jenkins << EOF
    until [ -f .jenkins/secrets/initialAdminPassword ]; do
        sleep 1
        echo "waiting for initial admin password"
    done
    until [[ -n "\$(cat  .jenkins/secrets/initialAdminPassword)" ]]; do
        sleep 1
        echo "waiting for initial admin password"
    done
    echo "initial admin password: \$(cat .jenkins/secrets/initialAdminPassword)"
    EOF

    curl https://get.docker.com | sudo bash
    sudo usermod -aG docker jenkins

    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl 
    EOF2
}