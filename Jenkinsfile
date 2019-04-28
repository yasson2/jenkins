pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh '''#install WGET
if ! [ -x "$(command -v wget)" ]; then
  sudo yum -y install wget
  exit 0
fi'''
        sh '''#install GIT
if ! [ -x "$(command -v git)" ]; then
  sudo yum -y install git
  exit 0
fi'''
        sh '''#install DOCKER
if ! [ -x "$(command -v docker)" ]; then
  sudo yum install -y yum-utils \\
  device-mapper-persistent-data \\
  lvm2
  sudo yum-config-manager \\
    --add-repo \\
    https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum -y install docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo docker run hello-world
  exit 0
fi'''
        sh '''#install MySQL
if ! [ -x "$(command -v mysql)" ]; then
  sudo yum -y install mysql
  exit 0
fi'''
      }
    }
  }
}