# Installs and configures Docker.

msg "Installing Docker..."
install_packages docker docker-compose

msg "Configuring Docker to limit log size..."
# This prevents log files from consuming excessive disk space.
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

msg "Enabling Docker service to start on boot..."
sudo systemctl enable docker

msg "Adding current user to the 'docker' group..."
# This allows running Docker commands without 'sudo'. A reboot or new login is required.
sudo usermod -aG docker "${USER}"
