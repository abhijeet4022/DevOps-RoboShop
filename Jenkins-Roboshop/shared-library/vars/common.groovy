def compile() {
    if (env.codeType == "nodejs") {
        print 'nodejs'
    }

    if (env.codeType == "java") {
        print 'java'
    }

    if (env.codetype == "python") {
        print 'python'
    }

    if (env.codeType == "static") {
        print 'static'
    }
}