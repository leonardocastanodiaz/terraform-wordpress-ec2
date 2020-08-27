
node {
    stage('Checkout') {
        checkout scm
    }

    stage('Clean Verify') {
        sh 'mvn clean verify'
    }

    if (env.BRANCH_NAME == "develop") {
        stage('Docker') {
            sh 'mvn docker:build -DpushImage'
        }
    }
}