  pipeline {
    agent {
      node {
        label "main"
      } 
    }

    stages {
      stage('fetch_latest_code') {
        steps {
          git credentialsId: '61910ec8-223a-45e2-90bf-b3772c4add41', url: 'https://github.com/PrachiP29/Terraform_Task'
        }
      }

      stage('TF Init&Plan') {
        steps {
          sh 'terraform init'
          sh 'terraform plan'
        }      
      }

      stage('Approval') {
        steps {
          script {
            def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
          }
        }
      }

      stage('TF Apply') {
        steps {
          sh 'terraform apply -input=false'
        }
      }
    } 
  }
