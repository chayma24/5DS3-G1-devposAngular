pipeline {
    agent any

    tools {
        nodejs 'NodeJS' 
    }

    environment {
        DOCKER_IMAGE = 'chaimagharbi-5ds3-g1-devopsangular'
        DOCKER_HUB_REPO = 'chayma24/5ds3-g1-devopsspring' 
        DOCKER_CREDENTIALS_ID = 'docker_id'
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/chayma24/5DS3-G1-devposAngular.git', 
                branch: 'ChaimaGharbi-5DS3-G1',
                credentialsId: 'jenkins_token_backend'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Angular Project') {
            steps {
                sh 'npm run build --prod'
            }
        }

        stage('Create Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image to DockerHub')  {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'ayana666#', usernameVariable: 'chayma24')]) {
                        sh 'docker login -u chayma24 -p ayana666#'
                        sh "docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_REPO}:latestAngular"
                        sh "docker push ${DOCKER_HUB_REPO}:latestAngular"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Angular project built and Docker image pushed to DockerHub successfully!'
        }
        failure {
            echo 'Build failed. Check the logs for errors.'
        }
    }
}

