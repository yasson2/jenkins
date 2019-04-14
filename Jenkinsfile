pipeline {
  agent any
  stages {
    stage('Prepare') {
      agent any
      steps {
        sh 'mkdir /tmp/$BUILD_TAG'
        dir(path: "/tmp/$BUILD_TAG") {
          writeFile(file: 'test', text: 'test', encoding: 'utf-8')
        }

        git(url: 'https://github.com/yasson2/jenkinstest.git', branch: 'master', credentialsId: '649a6f77-79a7-44ff-8358-4d12356b0b48')
        fileExists 'script.sh'
        echo 'Prepare complete !'
      }
    }
    stage('Deploy') {
      steps {
        sh '''chmod +x script.sh
./script.sh'''
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