pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        git(url: '$BUILD_SCRIPTS_GIT', branch: 'master', credentialsId: '	649a6f77-79a7-44ff-8358-4d12356b0b48')
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