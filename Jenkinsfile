
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(
                artifactDaysToKeepStr: '',
                artifactNumToKeepStr: '5',
                daysToKeepStr: '60',
                numToKeepStr: '10')
        )
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: 'HOURS')
    }
    stages {
        stage('Preparation') {
            steps {
                echo "Pull from bitbucket successful"
                snykSecurity failOnIssues: false, snykInstallation: 'Please define a Snyk installation in the Jenkins Global Tool Configuration. This task will not run without a Snyk installation.', snykTokenId: 'snyk-test'
            }
        }
        stage('Build') {
            steps {
                echo "Build starting"
            }
        }
        stage('Test') {
            steps {
                echo "Test was successful"
            }
        }
        stage('Build and Publish Docker Image to ECR') {
            steps {
                script {

                            echo " Publish to ECR"

                }
            }
        }
    }
}