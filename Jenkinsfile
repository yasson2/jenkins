pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh '''#install WGET
if ! [ -x "$(command -v wget)" ]; then
  sudo apt -y install wget
  exit 0
fi'''
        sh '''#install MySQL
if ! [ -x "$(command -v mysql)" ]; then
  sudo apt -y install mysql
  exit 0
fi'''
        sh '''#install DOCKER
if ! [ -x "$(command -v docker)" ]; then
sudo apt-get install \\
    apt-transport-https \\
    ca-certificates \\
    curl \\
    gnupg-agent \\
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 
sudo add-apt-repository \\
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \\
   $(lsb_release -cs) \\
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
  exit 0
fi'''
      }
    }
    stage('Build') {
      steps {
        echo 'test'
      }
    }
    stage('deploy') {
      agent any
      steps {
        sh 'docker stack deploy -c stack.yml wordpress'
      }
    }
    stage('test') {
      steps {
        echo 'test'
      }
    }
    stage('Repport') {
      steps {
        echo 'test'
      }
    }
    stage('Cleaning') {
      steps {
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, cleanupMatrixParent: true, deleteDirs: true, disableDeferredWipeout: true)
      }
    }
  }
}