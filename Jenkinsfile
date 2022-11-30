pipeline {
    agent any
    environment {
        def dockerImageName = "ellip-studio/studio-desktop:0.1"
        def dockerRegistry = "cr.terradue.com"
    }
     stages {
        stage('Build & Publish Docker') {
            steps {
                script {

                    dockerImage = docker.build "$dockerImageName"

                    docker.withRegistry("https://${dockerRegistry}", "robot-jenkins-harbor") {
                        docker.image("$dockerImageName").push()
                    }

                }
            }
        }
     }

}
