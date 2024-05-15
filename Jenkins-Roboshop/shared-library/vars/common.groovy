def compile() {
    if (env.codeType == "python" || env.codeType == "static") {
        return  'Return, Do not need Compilation'

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
        print 'Hello'
    }
}

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




