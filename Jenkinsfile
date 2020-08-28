pipeline {
    agent any
    stages {
        stage('test snyk') {
            steps {
               echo '##### SNYK #####'
            }
        }
        stage('snyk dependency scan') {
            tools {
                snyk 'snyk-test'
            }
            steps {
                snykSecurity failOnIssues: false, projectName: 'Demo', snykInstallation: 'snyk-test', snykTokenId: 'snyk-test'
            }
        }
    }
}