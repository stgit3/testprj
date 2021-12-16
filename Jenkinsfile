pipeline {
    agent  any
	
	parameters {
	  choices(name: 'Branches', choice: ['feature1','feature'], description: '')
       }
    stages {
        stage('build') {
            steps {
                echo  'building the application'
				echo "build app ${Branches}"
            }
        }
	}	
}
