def call() {

    pipeline {
        agent any

        options {
            ansiColor('xterm')
            buildDiscarder(logRotator(numToKeepStr: '3'))
        }

        parameters {
            string(name: 'COMPONENT', defaultValue: '', description: 'Which component to deploy?')
            string(name: 'VERSION', defaultValue: '', description: 'Which version to deploy?')
            string(name: 'ENV', defaultValue: '', description: 'Which environment to deploy?')
        }

        environment {
            SSH = credentials("centos-ssh")
        }

        stages {
            stage('Parameter Store Update') {
                steps {
                    sh '''
                        aws ssm put-parameter --name "${COMPONENT}.${ENV}.appVersion" --type "String" --value "${VERSION}" --overwrite
'''
                    script {
                        addShortText(text: "${ENV}-${COMPONENT}-${VERSION}")
                    }
                }
            }

            stage('Application Deployment') {
                steps {
                    sh '''
                        aws ec2 describe-instances --filters "Name=tag:Name,Values=prod-shipping" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text > inv
                        ansible-playbook -i inv Ansible-RoboShop/main.yml -e ansible_user=${SSH_USR} -e ansible_password=${SSH_PSW} -e component=${COMPONENT} -e env=${ENV}
'''

                }
            }
        }

    }
}


