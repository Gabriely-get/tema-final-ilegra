pipeline {
    environment { 
        AWS_ACCESS_KEY = credentials('aws_access_key')
        AWS_SECRET_KEY = credentials('aws_secret_key')
        AWS_SESSION_TOKEN = credentials('aws_session_token')
    }

    agent any

    stages {
        stage('Config Environment Credential') {
            steps {
                sh 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY'
                sh 'export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY"'
                sh 'export AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN"'
            }
        }
        stage('Packer Build Image') {
            steps {
                sh 'packer init build_ami_redis_ec2.pkr.hcl'
                sh 'packer validate build_ami_redis_ec2.pkr.hcl'
                sh 'packer build build_ami_redis_ec2.pkr.hcl'
            }
        }
    }
}