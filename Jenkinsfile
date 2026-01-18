pipeline {
    agent any

    environment {

        NEXUS_URL = "http://localhost:8081/repository/maven-releases/"
        NEXUS_REPO_ID = "nexus"
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

        stage('Deploy to Nexus') {
            steps {

                sh """
                mvn deploy -DskipTests \
                -DaltDeploymentRepository=${NEXUS_REPO_ID}::default::${NEXUS_URL}
                """
            }
        }
    }
}
