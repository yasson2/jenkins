pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh '''#install WGET
if ! [ -x "$(command -v wget)" ]; then
  sudo yum-y install wget
  exit 0
fi'''
        sh '''#install MySQL
if ! [ -x "$(command -v mysql)" ]; then
  sudo yum -y install mysql
  exit 0
fi'''
        sh '''#install DOCKER
if ! [ -x "$(command -v docker)" ]; then
  sudo yum install -y docker
  sudo systemctl start docker
    sudo systemctl enable docker
    sudo docker run hello-world
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