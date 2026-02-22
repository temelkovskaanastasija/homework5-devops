pipeline {
  agent any

  environment {
    IMAGE_NAME = "homework3-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
  }

  stages {

    stage('Prep') {
      steps {
        sh 'git config --global --add safe.directory /var/jenkins_home/workspace/* || true'
        sh 'chmod +x scripts/*.sh || true'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Unit Tests') {
      steps {
        // само unit test (за да не заглавува IntegrationTest)
        sh 'mvn -Dtest=HomeworkTest test'
      }
    }

    stage('Integration Check (Container Health)') {
      steps {
        // Наместо java -jar + IntegrationTest, ќе тестираме реален container /health
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
        '''
      }
    }

    stage('Deploy SNAPSHOT to Nexus') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'nexus-creds',
          usernameVariable: 'NEXUS_USER',
          passwordVariable: 'NEXUS_PASS'
        )]) {
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

    stage('Detect Active Environment') {
      steps {
        script {
          env.ACTIVE_ENV = sh(script: './scripts/detect_active.sh', returnStdout: true).trim()
          env.TARGET_ENV = (env.ACTIVE_ENV == 'blue') ? 'green' : 'blue'

          echo "Active env: ${env.ACTIVE_ENV}"
          echo "Target env: ${env.TARGET_ENV}"
        }
      }
    }

stage('Deploy to Inactive Environment') {
  steps {
    sh '''
     APP_VERSION=${IMAGE_TAG} docker-compose -p homework3 -f docker-compose.bg.yml up -d --no-deps --force-recreate app-${TARGET_ENV}
    '''
  }
}

    stage('Validate Inactive Environment') {
      steps {
        sh '''
          sleep 5
          docker exec app-${TARGET_ENV} curl -f http://localhost:8080/health
          docker exec app-${TARGET_ENV} curl -f http://localhost:8080/version
        '''
      }
    }

    stage('Switch Traffic (Nginx)') {
      steps {
        sh '''
          if [ "${TARGET_ENV}" = "green" ]; then
            ./scripts/switch_to_green.sh
          else
            ./scripts/switch_to_blue.sh
          fi
        '''
      }
    }

    stage('Final Validation via Reverse Proxy') {
      steps {
        // Jenkins е во container, затоа host.docker.internal
        sh 'curl -f http://host.docker.internal/version'
      }
    }
  }

  post {
    failure {
      echo 'Pipeline failed. Rolling back traffic...'
      sh './scripts/rollback.sh || true'
    }
  }
}