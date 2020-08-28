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
                snykSecurity(
                        organisation: '',
                        severity: 'high',
                        snykInstallation: 'snyk-test',
                        snykTokenId: 'snyk-test',
                        targetFile: '',
                        failOnIssues: 'false'
                )
            }
        }
    }
}