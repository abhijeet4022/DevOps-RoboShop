def compile() {
    if (env.codeType == "python" || env.codeType == "static") {
        print 'Return, Do not need Compilation'
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
    stage('Test') {
        print 'Test'
    }
}

def codeQuality() {
    stage('Code Quality') {
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




