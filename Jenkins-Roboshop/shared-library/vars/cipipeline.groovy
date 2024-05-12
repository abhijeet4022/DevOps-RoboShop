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
                steps {
                    echo 'Compiling The Code.'
                }
            }
            stage('Test') {
                when {
                    expression { env.TAG_NAME == null }
                }
                steps {
                    echo 'Test The Code.'
                }
            }
            stage('Code Quality') {
                when {
                    expression { env.TAG_NAME == null }
                }
                steps {
                    echo 'Code Quality'
                }
            }
            stage('Code Security') {
                when {
                    expression { BRANCH_NAME == "main" }
                }
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