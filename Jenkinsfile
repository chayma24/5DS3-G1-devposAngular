pipeline {
    agent any

    tools {
        nodejs 'NodeJS' 
    }

    environment {
        SONAR_TOKEN = 'sonarcloud_token'
        DOCKER_CONFIG_SECRET = 'docker_id'
        DOCKER_IMAGE_NAME = 'chayma24/5ds3-g1-devopsangular'
        GITHUB_REPO_URL = 'https://github.com/chayma24/5DS3-G1-devposAngular.git'
        GIT_BRANCH = 'ChaimaGharbi-5DS3-G1'
        ANGULAR_PROJECT_NAME = '5DS3-G1-devposAngular'
    }



    stages {
        stage('Clone') {
            steps {
                git url: "${env.GITHUB_REPO_URL}",
                    branch: "${env.GIT_BRANCH}",
                    credentialsId: 'jenkins_token_backend'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir(env.ANGULAR_PROJECT_NAME) {
                    sh 'npm install'
                }
            }
        }

       
        stage('Build') {
            steps {
                dir(env.ANGULAR_PROJECT_NAME) {
                    sh 'npm run build --prod' 
                }
            }
        }

        stage('SonarCloud Analysis') {
            steps {
                withCredentials([string(credentialsId: env.SONAR_TOKEN, variable: 'SONAR_TOKEN')]) {
                    dir(env.ANGULAR_PROJECT_NAME) {
                        sh '''
                        npx sonar-scanner \
                            -Dsonar.projectKey=chayma24 \
                            -Dsonar.organization=chayma24 \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                dir("${env.ANGULAR_PROJECT_NAME}/dist") {
                    archiveArtifacts artifacts: '**', fingerprint: true
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                dir(env.ANGULAR_PROJECT_NAME) {
                    script {
                        def imageTag = "${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"

                        // Build the Docker image
                        docker.build(imageTag, "--build-arg ANGULAR_DIST_DIR=dist/${env.ANGULAR_PROJECT_NAME} .")

                        // Log in and push the Docker image
                        withCredentials([usernamePassword(credentialsId: env.DOCKER_CONFIG_SECRET, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin'
                            docker.image(imageTag).push()
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            cleanWs() 
        }
    }
}


