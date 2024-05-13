def compile() {
    if (env.codeType == "nodejs") {
        print 'nodejs'
    }

    if (env.codeType == "maven") {
        sh 'env'
        print 'maven'
    }

    if (env.codetype == "python") {
        print 'python'
    }

    if (env.codeType == "static") {
        print 'static'
    }
}