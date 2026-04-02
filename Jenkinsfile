pipeline {
    agent any

    environment {
        IMAGE_NAME = "task1-app"
        CONTAINER_NAME = "task1-container"
        PORT = "5500"
    }

    stages {
        stage('Clean Up') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker image prune -f || true
                    rm -f trivy-report.txt || true
                '''
            }
        }

        stage('Set Up') {
            steps {
                checkout scm
                sh '''
                    pwd
                    ls -la
                '''
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}
                    sleep 5
                    curl http://localhost:${PORT}
                '''
            }
        }

        stage('Manual Browser Check') {
            steps {
                input message: "Check the app in browser at http://EC2_PUBLIC_IP:${PORT} and click Proceed"
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    trivy fs . > trivy-report.txt || true
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.txt', allowEmptyArchive: true
        }
    }
}
