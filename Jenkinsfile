pipeline {
    agent  any
	
	parameters {
	  choice(name: 'Branches', choice: ['feature1','feature'], description: '')
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
