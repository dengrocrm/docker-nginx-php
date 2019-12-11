pipeline {
    agent any
    environment {
        registry = '448781339860.dkr.ecr.eu-west-1.amazonaws.com/nginx-php:latest'
    }
    stages {
        stage("Docker Build") {
            steps {
                sh "docker build -t nginx-php:latest ."
            }
        }
        stage("ECR Login") {
            steps {
                withAWS(credentials:'awsCredentials') {
                    script {
                        def login = ecrLogin()
                        sh "${login}"
                    }
                }
            }
        }
        stage("Docker Push") {
            steps {
                sh "docker push ${registry}"
            }
        }
    }
}