pipeline {
    
    agent any
    
    tools {
        maven 'Maven'
    }
    
    stages {
        stage('checkout') {
            steps{
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/stgit3/testprj.git']]])
            }
        }
        stage('Build'){
            steps{
            sh 'mvn clean install -f webapp/pom.xml'
            }
        }
        stage('s3 upload') {
            steps {
              s3Upload consoleLogLevel: 'INFO', dontSetBuildResultOnFailure: false, dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 's34s5', excludedFile: '/webapp/target', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: false, selectedRegion: 'us-east-2', showDirectlyInBrowser: false, sourceFile: '**/webapp/target/*.war', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false]], pluginFailureResultConstraint: 'FAILURE', profileName: 's34s5', userMetadata: []  
            }
            
        }
    }
}
