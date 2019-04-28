pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        fileExists 'stack.yml'
        sh 'sudo docker stack deploy -c stack.yml wordpress'
        sleep 20
      }
    }
    stage('Test') {
      steps {
        sh 'wget http://ec2-35-181-91-136.eu-west-3.compute.amazonaws.com'
      }
    }
    stage('Cleaning') {
      steps {
        sh 'sudo docker stack rm wordpress'
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, cleanupMatrixParent: true, deleteDirs: true, disableDeferredWipeout: true)
      }
    }
  }
}