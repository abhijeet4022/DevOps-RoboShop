def call() {
    node('workstation') {

        sh "find . | sed -e '1d' | xargs rm -rf "
        git branch: 'main', url: "https://github.com/abhijeet4022/${component}"


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

