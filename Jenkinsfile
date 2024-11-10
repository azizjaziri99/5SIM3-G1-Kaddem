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
        DOCKER_IMAGE = 'azizjaziri544/kaddem:latest'
        JAR_NAME = ""
    }

    stages {
        stage('GIT') {
            steps {
                echo 'Getting project from git...'
                git branch: "${BRANCH_NAME}", url: "${GIT_REPO}"
            }
        }
        stage('Increment Version') {
            steps {
                echo 'Incrementing project version with SNAPSHOT...'
                script {
                    sh '''
                        CURRENT_VERSION=$(mvn -q \
                            -Dexec.executable=echo \
                            -Dexec.args='${project.version}' \
                            --non-recursive exec:exec)
                        
                        # Increment the patch version, for example from 0.1.2 to 0.1.3
                        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{OFS="."; $NF++; print}')
                        SNAPSHOT_VERSION="${NEW_VERSION}-SNAPSHOT"
                        
                        # Set the new version in pom.xml
                        mvn versions:set -DnewVersion=$SNAPSHOT_VERSION
                        mvn versions:commit
                    '''
                }
            }
        }
        
        stage('MVN CLEAN') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean package -DskipTests'
                script {
                    // Capture the generated JAR name
                    env.JAR_NAME = sh(
                        script: "ls target/*.jar | head -n 1 | xargs basename",
                        returnStdout: true
                    ).trim()
                    echo "Generated JAR Name: ${env.JAR_NAME}"
                }
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
                echo 'Building Docker image...'
                script {
                    // Pass the JAR name as a build argument to Docker
                    sh "docker build -t ${DOCKER_IMAGE} --build-arg JAR_FILE=${env.JAR_NAME} ."
                }
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withEnv(['DOCKER_USER=azizjaziri544', 'DOCKER_PASS=09894276*']) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker push ${DOCKER_IMAGE}
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
