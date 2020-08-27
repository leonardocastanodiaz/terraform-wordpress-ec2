pipeline {
    agent any
    stages {
        stage('snyk dependency scan') {
            tools {
                snyk 'snyk-latest'
            }
            steps {
                snykSecurity(
                        organisation: 'cloudbees',
                        severity: 'high',
                        snykInstallation: 'snyk-latest',
                        snykTokenId: 'snyk-test',
                        targetFile: 'requirements.txt',
                        failOnIssues: 'true'
                )
            }
        }
    }
}