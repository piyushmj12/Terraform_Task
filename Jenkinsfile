pipeline {
    agent any
    
    tools {
        terraform 'terraform-configuration'
    }
    stages {
        stage ("checkout from GIT") {
            steps {
                git branch: 'main', credentialsId: '61910ec8-223a-45e2-90bf-b3772c4add41', url: 'https://github.com/PrachiP29/Terraform_Task'
            }
        }
        stage ("terraform ls") {
            steps {
                sh 'ls'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        
        stage ("terraform validate") {
            steps {
                sh 'terraform validate'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
