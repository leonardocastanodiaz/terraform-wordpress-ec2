pipeline {
    agent any
    stages {
        stage('test snyk') {
            step {
               sh 'ls '
            }
        }
        stage('snyk dependency scan') {
            tools {
                snyk 'snyk-test'
            }
            steps {
                snykSecurity(
                        organisation: 'cloudbees',
                        severity: 'high',
                        snykInstallation: 'snyk-test',
                        snykTokenId: 'snyk-test',
                        failOnIssues: 'false'
                )
            }
        }
    }
}