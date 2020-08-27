pipeline {
    agent any
    stages {
        stage('test snyk') {
            steps {
               sh 'npm install -g snyk'
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