pipeline {
    agent any

    environment {
        IMAGE_NAME = "aachman7696/drivee"
    }

    stages {
        stage('Checkout') {
            steps {
                // Replace with your actual GitHub repo URL
                git branch: 'main', url: 'https://github.com/AA7696/rentals.git'
                
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sh '''
                    docker pull $IMAGE_NAME:latest
                    docker stop drivee || true
                    docker rm drivee || true
                    docker run -d -p 80:80 --name drivee $IMAGE_NAME:latest
                '''
            }
        }
    }
}
