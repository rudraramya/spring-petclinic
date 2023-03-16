pipeline {
   agent { node { label 'node' } }
   triggers { pollSCM ('H */4 * * 1-5') }
   stages {
    stage('mvnbuilding') {
        steps {
            sh'''

            /home/rudraramya/apache-maven-3.9.0/bin/mvn package
            '''
        }
        }
        stage(publishing_results) {
        steps {
            junit 'target/surefire-reports/*.xml'
        }
        }
        stage(infracreation) {
            steps {
                sh'''
                cd infra
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
    }
   }

this is change in dev