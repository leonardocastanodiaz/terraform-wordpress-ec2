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
                snykSecurity failOnIssues: false, projectName: 'Demo', snykInstallation: 'Please define a Snyk installation in the Jenkins Global Tool Configuration. This task will not run without a Snyk installation.', snykTokenId: 'snyk-cloud-subscriptions'
            }
        }
    }
}