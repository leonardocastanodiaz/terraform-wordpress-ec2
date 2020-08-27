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
                        targetFile: 'Dockerfile',
                        packageManager: 'pip',
                        failOnIssues: 'false'
                )
            }
        }
    }
}