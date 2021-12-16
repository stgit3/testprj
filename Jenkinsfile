pipeline {
    agent  any
	
	parameters {
	  choice(name: 'Branches', choices: ['feature1','feature'], description: '')
       }
    stages {
        stage('build') {
            steps {
                echo  'building the applications'
				echo "build app ${Branches}"
            }
        }
	}	
}
