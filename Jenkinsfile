pipeline {
    agent {
        label 'nfapp'
    }

    stages {
        stage('sync_request') {
            steps {
                withCredentials([usernameColonPassword(credentialsId: 'GitHub_StatelessOtto2', variable: 'USERPASS')]) {
                    sh './jenkin-scripts/sync_request.sh'
                }
            }
        }
    }

    post {
        success {
            slackSend channel: '#jenkins',
                      color: 'good',
                      message: "Build succeeded for charon ${env.BRANCH_NAME} -- ${env.CHANGE_TITLE}"
        }
        failure {
            slackSend channel: '#jenkins',
                      color: 'danger',
                      message: "Build failed for charon ${env.BRANCH_NAME} -- ${env.CHANGE_TITLE}"
        }
    }
}
