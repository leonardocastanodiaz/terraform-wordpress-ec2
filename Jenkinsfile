pipeline {
    agent any
    stages {
        stage('test snyk') {
            steps {
               echo '#########'
            }
        }
        stage('snyk dependency scan') {
            tools {
                snyk 'snyk-test'
            }
            steps {
                stageScanForSnyk(context, snykAuthenticationCode, 'build.gradle', context.projectId)
            }
        }
    }
}