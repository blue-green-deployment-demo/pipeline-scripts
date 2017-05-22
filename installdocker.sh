curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run hello-world
sudo docker ps -a
