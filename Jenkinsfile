def IMAGE_NAME = "image-name"
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
             sh 'snyk monitor --docker $IMAGE_NAME --file=Dockerfile'
            }
        }
    }
}