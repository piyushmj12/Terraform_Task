pipeline {
    agent any
    
    tools {
        terraform 'Terraform-Configuration'
    }
    stages {
        stage ("checkout from GIT") {
            steps {
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/PrachiP29/Terraform_Task'
            }
        }
        stage ("terraform ls") {
            steps {
                sh 'ls'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init -reconfigure'
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
