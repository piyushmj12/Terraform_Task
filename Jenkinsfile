pipeline{
    agent any
    
    stages{
        stage('Git Checkout'){
            steps{
                git branch: 'main', credentialsId: '61910ec8-223a-45e2-90bf-b3772c4add41', url: 'https://github.com/PrachiP29/Terraform_Task'
                
            }
        }
         stage('Terraform Init '){
            steps{
                sh label: '', script: 'terraform init'
            }
        }
    }
}
