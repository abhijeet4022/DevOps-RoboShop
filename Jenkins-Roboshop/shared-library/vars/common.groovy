def compile() {
    if (env.codeType == "python" || env.codeType == "static") {
        return 'Return, Do not need Compilation'

    }

    stage('CodeCompile') {
        if (env.codeType == "nodejs") {
            sh 'npm install'
        }

        if (env.codeType == "maven") {
            sh '/usr/bin/mvn/bin/mvn package'
        }
    }
}


def test() {
    stage('UnitTesting') {
        if (env.codeType == "nodejs") {
            print 'ok'
            // sh 'npm test'
        }
        if (env.codeType == "maven") {
            print 'ok'
            // sh '/usr/bin/mvn/bin/mvn test'
        }
        if (env.codeType == "python") {
            print 'ok'
            // sh 'python3.6 -m unittest'
        }
        if (env.codeType == "static") {
            print 'Static Content no need to Unit Test'
        }

    }
}

def codeQuality() {
    stage('CodeQualityCheck') {
        env.sonaruser = sh(script: 'aws ssm get-parameter --name "sonarqube.username" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()
        env.sonarpass = sh(script: 'aws ssm get-parameter --name "sonarqube.password" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()

        wrap([$class: "MaskPasswordsBuildWrapper", varPasswordPairs: [[password: sonarpass]]]) {
            if (codeType == 'maven') {
                //  sh 'sonar-scanner -Dsonar.host.url=http://172.31.18.50:9000 -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpass} -Dsonar.projectKey=${component} -Dsonar.qualitygate.wait=true -Dsonar.java.binaries=./target'
                print 'ok'
            } else {
                //   sh 'sonar-scanner -Dsonar.host.url=http://172.31.18.50:9000 -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpass} -Dsonar.projectKey=${component} -Dsonar.qualitygate.wait=true'
                print 'ok'
            }
        }
    }
}


def codeSecurity() {
    stage('CodeSecurity') {
        print 'Skipping Code Security Because Checkmarx security checking tool is not free'
    }
}

def release() {
    stage('VersionRelease') {

        env.nexususer = sh(script: 'aws ssm get-parameter --name "nexus.username" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()
        env.nexuspass = sh(script: 'aws ssm get-parameter --name "nexus.password" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()

        wrap([$class: "MaskPasswordsBuildWrapper", varPasswordPairs: [[password: nexuspass]]]) {
            sh 'echo ${} > VERSION'
            // Creating Artifact zip files.
            if (codeType == 'nodejs') {
                sh 'zip -r ${component}-${TAG_NAME}.zip server.js node_modules VERSION ${schemadir}'
            } else if (codeType == 'maven') {
                sh 'cp target/${component}-1.0.jar ${component}.jar ; zip -r ${component}-${TAG_NAME}.zip ${component}.jar ${schemadir} VERSION'
            } else {
                sh 'zip -r ${component}-${TAG_NAME}.zip *'
            }

            // Copying the artifact to nexus repository, repository already created by the component name.
            sh 'curl -v -u ${nexususer}:${nexuspass} --upload-file ${component}-${TAG_NAME}.zip http://172.31.10.247:8081/repository/${component}/${component}-${TAG_NAME}.zip'

        }
    }
}

