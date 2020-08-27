pipeline {
    agent any
    stages {
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
                        targetFile: '*.tf',
                        failOnIssues: 'true'
                )
            }
        }
    }
}