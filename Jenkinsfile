pipeline {
  agent any
  stages {
    stage('Prepare') {
      agent any
      steps {
        git(url: 'https://github.com/yasson2/jenkinstest.git', branch: 'master', credentialsId: '649a6f77-79a7-44ff-8358-4d12356b0b48')
        fileExists 'script.sh'
        echo 'Prepare complete !'
      }
    }
    stage('Deploy') {
      steps {
        sh 'touch /tmp/1.txt'
        echo 'Deploy completed !'
      }
    }
    stage('Test') {
      steps {
        sh '[ -f "/tmp/1.txt" ] && echo "/tmp/1.txt exist"'
        echo 'FIle exist !'
      }
    }
    stage('Clean') {
      steps {
        cleanWs()
        sh 'rm -rf /tmp/1.txt'
      }
    }
  }
}