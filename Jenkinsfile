pipeline {
    agent none
     parameters {
        choice(name: 'Infra_Setup', choices: ['yes', 'no'], description: 'Choose an action')
        choice(name: 'Terraform_Destory', choices: ['yes', 'no'], description: 'Choose an action')
        choice(name: 'Terraform_Apply', choices: ['yes', 'no'], description: 'Choose an action')
     }
     stages {
        stage('Infra_Setup'){
             when {
        expression { return params.Infra_Setup == 'yes' }
    }
             agent { label 'Dev' }
             stages{
                stage('Software_Check'){
                    steps{
                        sh 'mvn -version'
                        sh 'terraform version'
                        sh 'packer version'
                    }
                }
                stage('Terraform_Plan'){
                    steps{
                        sh 'terraform init'
                        sh 'terraform plan'
                    }
                }
                stage('Terraform_Apply'){
                    when {
                        expression { return params.Terraform_Apply == 'yes' }
                    }
                    steps{
                        sh 'terraform apply --auto-approve'
                    }
                }
                stage('Terraform_Destory'){
                    when {
                        expression { return params.Terraform_Destory == 'yes' }
                    }
                    steps{
                        sh 'terraform destroy --auto-approve'
                    }
                }
             }
        }
     }
}