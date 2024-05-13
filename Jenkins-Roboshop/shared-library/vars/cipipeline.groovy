def call() {
    node('workstation') {

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


        stage('Complie Code'){
            common.compile()
        }
        stage('Test'){
            print 'Test'
        }
        stage('Code Quality'){
            print 'Hello'
        }
        stage('Code Security'){
            print 'Hello'
        }
        stage('Release'){
            print 'Hello'
        }
    }
}

