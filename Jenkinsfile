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
        sh 'chmod +X script.sh'
        sh './script.sh'
        echo 'Deploy completed !'
      }
    }
    stage('Test') {
      steps {
        sh '[ -f "/tmp/1.txt" ] && echo "/tmp/1.txt exist"'
      }
    }
    stage('Clean') {
      steps {
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true, disableDeferredWipeout: true, cleanupMatrixParent: true)
      }
    }
  }
  environment {
    BUILD_SCRIPTS_GIT = 'https://github.com/yasson2/jenkinstest.git'
    BUILD_SCRIPTS = 'mypipeline'
    BUILD_HOME = '/var/lib/jenkins/workspace'
    FILE = '/tmp/1.txt'
  }
}