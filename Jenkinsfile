pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'http://gitea:3000/anastasijatemelkovska/homework-two.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Deploy to Nexus') {
            steps {
                sh 'mvn deploy -DrepositoryId=nexus -Durl=http://nexus:8081/repository/maven-releases/'
            }
        }
    }
}
