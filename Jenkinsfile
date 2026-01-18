pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'http://localhost:3000/anastasijatemelkovska/homework-two.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}
