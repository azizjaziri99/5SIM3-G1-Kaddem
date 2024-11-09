pipeline {
    agent any 

    tools {
        maven 'M2_HOME' //Maven version
        jdk 'JAVA_HOME' 
    }

    environment {
        PROJECT_NAME = "kaddem"
        GIT_REPO = "https://github.com/azizjaziri99/5SIM3-G1-Kaddem"
        BRANCH_NAME = "MedAzizJaziri-5SIM3-G1"
        SONARQUBE_SERVER = "sonarqube"
       
    }

    stages {
        stage('GIT') {
            steps {
                echo 'Getting project from git...'
                git branch: "${BRANCH_NAME}", url: "${GIT_REPO}"
            }
        }
        
        stage('MVN CLEAN') {
            steps {
                echo 'Running Maven clean...'
                sh 'mvn clean'
            }
        }

        stage('MVN COMPILE') {
            steps {
                echo 'Running Maven compile...'
                sh 'mvn compile'
            }
        }
        
        stage ('SONARQUBE') {
            steps {
                sh 'mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=adminn -Dmaven.test.skip=true';
            }
        }


        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('NEXUS') {
            steps {
                echo 'Deploying to Nexus...'
                sh 'mvn deploy -Dusername=admin -Dpassword=adminn -Dmaven.test.skip=true'
            }
        }
        stage('Building Image') {
            steps {
                sh 'docker --version'

                sh 'docker build -t azizjaziri544/kaddem:1.0.0 .'
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                withEnv(['DOCKER_USER=azizjaziri544', 'DOCKER_PASS=09894276*']) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker push azizjaziri544/kaddem:1.0.0
                    '''
                }
            }
        }
    }
    

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'SUCCESS.'
        }
        failure {
            echo 'FAIL.'
        }
    }
}
