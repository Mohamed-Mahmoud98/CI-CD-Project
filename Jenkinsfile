pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mohababdelaal/movie_website"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('Website_image') {
                    sh 'docker rmi mohababdelaal/movie_website:latest || true'
                    sh 'docker build --no-cache -t $DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASS')]) {
                    sh 'echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                        cp $KUBECONFIG_FILE $WORKSPACE/kubeconfig
                        export KUBECONFIG=$WORKSPACE/kubeconfig
                        kubectl apply -f k3s/deployment.yml
                        kubectl apply -f k3s/service.yml
                        kubectl apply -f k3s/ingress.yml
                        kubectl apply -f k3s/albservice.yml
                    '''
                }
            }
        }
    }
}
