def compile() {
    if (env.codeType == "nodejs") {
        print 'nodejs'
    }

    if (env.codeType == "maven") {
        sh 'env'
        print 'maven'
        sh '/usr/bin/mvn/bin/mvn package'
    }

    if (env.codetype == "python") {
        print 'python'
    }

    if (env.codeType == "static") {
        print 'static'
    }
}