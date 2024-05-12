def call() {
    node('workstation') {

        sh "find . | sed -e '1d' | xargs rm -rf "


        stage('Complie Code'){
            common.compile()
        }

        stage('Test'){
            print 'Test'
        }

        stage('Code Quality'){
            print 'Hello'
        }

        stage('Code Security'){
            print 'Hello'
        }

        stage('Release'){
            print 'Hello'
        }





    }

}

def calll() {
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
                    expression { env.BRANCH_NAME != null }
                    expression { env.TAG_NAME == null }
                }
                steps {
                    echo 'Test The Code.'
                }
            }
            stage('Code Quality') {
                when {
                    expression { env.BRANCH_NAME != null }
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