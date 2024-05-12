def call() {
    pipeline {
        agent { node { label 'workstation' } }
        triggers { pollSCM('*/1 * * * *') }
        options {
            ansiColor('xterm')
            buildDiscarder(logRotator(numToKeepStr: '3'))
       }
        stages {
            stage('Compile Code') {
                when {
                    expression { env.TAG_NAME == null }
                }
                steps {
                    echo 'Compiling The Code.'
                }
            }
            stage('Test') {
                steps {
                    echo 'Test The Code.'
                }
            }
            stage('Code Quality') {
                steps {
                    echo 'Code Quality'
                }
            }
            stage('Code Security') {
                steps {
                    echo 'Code Security'
                }
            }
            stage('Release') {
                when {
                    expression { env.TAG_NAME ==~ ".*" }
                }
                steps {
                    sh 'env'
                }
            }
        }
    }
}