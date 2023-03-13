pipeline {
   agent { node { label 'gol2' } }
   trigger { cron('H */4 * * 1-5') }
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