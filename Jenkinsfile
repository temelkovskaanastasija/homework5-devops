pipeline {
    agent any

    environment {

        NEXUS_URL = "http://localhost:8081/repository/maven-releases/"
        NEXUS_REPO_ID = "nexus"
    }
    tools {
        maven 'M3'
    }

    stages {
        stage('Checkout') {
            steps {

                git url: 'http://host.docker.internal:3000/anastasijatemelkovska/homework-two.git',
                 branch: 'master',
                  credentialsId: 'gitea-creds'
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



    }
}
