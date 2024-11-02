pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pulls the latest code from the Git repository
                git branch: 'MedAzizJaziri-5SIM3-G1', url: 'https://github.com/azizjaziri99/5SIM3-G1-Kaddem'
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                // Ensure you have configured the Maven tool in Jenkins (e.g., 'Maven 3.6.3')
                script {
                    def mvnHome = tool name: 'Maven 3.6.3'
                    sh "${mvnHome}/bin/mvn clean compile"
                }
            }
        }

        stage('Test') {
            steps {
                // Run tests
                script {
                    def mvnHome = tool name: 'Maven 3.6.3'
                    sh "${mvnHome}/bin/mvn test"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and Test stages completed successfully.'
        }
        failure {
            echo 'Build or Test stage failed.'
        }
    }
}
