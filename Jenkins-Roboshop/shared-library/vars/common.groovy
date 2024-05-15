def compile() {
    if (env.codeType == "python" || env.codeType == "static") {
        return 'Return, Do not need Compilation'

    }

    stage('Compile Code') {
        if (env.codeType == "nodejs") {
            sh 'npm install'
        }

        if (env.codeType == "maven") {
            sh '/usr/bin/mvn/bin/mvn package'
        }
    }
}


def test() {
    stage('UnitTest') {
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
    stage('CodeQuality') {
        env.sonaruser = sh (script: 'aws ssm get-parameter --name "sonarqube.username" --with-decryption --query="Parameter.Value" | xargs', returnStdout: true).trim()

        env.sonarpass = sh (script: 'aws ssm get-parameter --name "sonarqube.password" --with-decryption --query="Parameter.Value" | xargs', returnStdout: true).trim()

        wrap([$class: "MaskPasswordsBuildWrapper", varPasswordPairs: [[password: sonarpass]]]) {
            sh 'sonar-scanner -Dsonar.host.url=http://172.31.18.50:9000 -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpass} -Dsonar.projectKey=${component} -Dsonar.qualitygate.wait=true'
        }
    }
}

//def codeQuality2() {
//    stage('Code Quality') {
//        env.sonaruser = sh (script: 'aws ssm get-parameter --name "sonarqube.user" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()
//        env.sonarpass = sh (script: 'aws ssm get-parameter --name "sonarqube.pass" --with-decryption --query="Parameter.Value" |xargs', returnStdout: true).trim()
//        wrap([$class: "MaskPasswordsBuildWrapper", varPasswordPairs: [[password: sonarpass]]]) {
//            if(env.codeType == "maven") {
//                //sh 'sonar-scanner -Dsonar.host.url=http://172.31.89.117:9000 -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpass} -Dsonar.projectKey=${component} -Dsonar.qualitygate.wait=true -Dsonar.java.binaries=./target'
//                print 'OK'
//            }else {
//                //sh 'sonar-scanner -Dsonar.host.url=http://172.31.89.117:9000 -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpass} -Dsonar.projectKey=${component} -Dsonar.qualitygate.wait=true'
//                print 'OK'
//            }
//        }
//    }
//}









def codeSecurity() {
    stage('Code Security') {
        print 'Hello'
    }
}

def release() {
    stage('Release') {
        print 'Hello'
    }
}


//

// sonar-scanner -Dsonar.host.url=http://172.31.18.50:9000 -Dsonar.login=admin -Dsonar.password=DevOps321 -Dsonar.projectKey=cart -Dsonar.qualitygate.wait=true
