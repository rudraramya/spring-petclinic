pipeline {
   agent { node { label 'gol2' } }
   trigger { pollSCM ('H */4 * * 1-5') }
   stages {
    stage('mvnbuilding') {
        steps {
            sh'''
            mvn package
            '''
        }
        steps {
            junit 'target/surefire-reports/*.xml'
        }
    }
   }
}