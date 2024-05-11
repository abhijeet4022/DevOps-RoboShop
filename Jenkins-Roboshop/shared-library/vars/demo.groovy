def info(message) {
    echo "INFO: ${message}"
}

def warning(message) {
    echo "WARNING: ${message}"
}

def call() {
    pipeline {
        agent { node { label 'workstation' } }
        stages {
            stage('Compile Code') {
                steps {
                    echo 'Compiling The Code.'
                    script {
                        info 'Starting'
                        warning 'Nothing to do!'
                    }
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
        }
    }
}