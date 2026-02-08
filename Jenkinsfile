pipeline {
  agent {
    docker { image 'maven:3.9.6-eclipse-temurin-21' }
  }

  stages {
    stage('Clean') {
      steps { deleteDir() }
    }

    stage('Prep') {
      steps {
        sh 'git config --global --add safe.directory /var/jenkins_home/workspace/* || true'
      }
    }

    stage('Build & Test') {
      steps {
        sh 'mvn clean test'
      }
    }

    stage('Deploy SNAPSHOT to Nexus') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
          sh '''
            cat > settings.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF
            mvn -s settings.xml deploy
          '''
        }
      }
    }
  }
}
