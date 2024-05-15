def call() {
    node('workstation') {

        triggers { pollSCM('*/1 * * * *') }

        sh "find . | sed -e '1d' | xargs rm -rf "

        // Continuous download the developer code for application from repo for build test.
        // If tag is specified in repo then download the code from tag if not then from branch..
        if (env.TAG_NAME ==~ ".*") {
            env.branch_name = "refs/tags/${env.TAG_NAME}"
        } else {
            env.branch_name = "${env.BRANCH_NAME}"
        }
        checkout scmGit(
                branches: [[name: branch_name]],
                userRemoteConfigs: [[url: "https://github.com/abhijeet4022/${component}"]]
        )


        // Now Create condition to run the stages as per Branch and Tags.

        if (env.TAG_NAME ==~ ".*") {
            common.compile()
            common.release()
        } else {
            if (env.BRANCH_NAME == "main") {
                common.compile()
                common.test()
                common.codeQuality()
                common.codeSecurity()
            } else {
                common.compile()
                common.test()
                common.codeQuality()
                }
            }
    }
}

