pipeline {
  agent any
  stages {
    stage('Prepare') {
      agent any
      steps {
        git(url: '${env.BUILD_SCRIPTS_GIT}', branch: 'master', credentialsId: '649a6f77-79a7-44ff-8358-4d12356b0b48')
        fileExists 'script.sh'
        echo 'Prepare complete !'
      }
    }
    stage('Deploy') {
      steps {
        sh '${env.WORKSPACE}/script.sh'
        echo 'Deploy completed !'
      }
    }
    stage('Test') {
      environment {
        FILE = '/tmp/1.txt'
      }
      steps {
        sh '[ -f ${FILE} ] && echo "${FILE} exist"'
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