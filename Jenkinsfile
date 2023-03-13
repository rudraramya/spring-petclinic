pipeline {
   agent { node { label 'node' } }
   triggers { pollSCM ('H */4 * * 1-5') }
   stages {
    stage('mvnbuilding') {
        steps {
            sh'''
            mvn package
            '''
        }
        }
        stage(publishing_results) {
        steps {
            junit 'target/surefire-reports/*.xml'
        }
        }
    }
   }
