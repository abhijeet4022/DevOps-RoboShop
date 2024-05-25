pipeline {

    agent any

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }

    environment {
        SSH = credentials("centos-ssh")
    }

    stages {
        stage('SSH') {
            steps {
                echo "${SSH_PSW}"
                echo "${SSH_USR}"
            }
        }
    }

}



