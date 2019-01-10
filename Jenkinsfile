properties([parameters([choice(name: 'CHOICES', choices: ['master', 'dev', 'huqiang'], description: '')])])
node('stag-jnlp-slave') {
    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            if (env.BRANCH_NAME != '${params.CHOICES}') {
		echo "curr env.BRANCH_NAME"
            }
        }
    }
    stage('Test') {
      echo "2.Test Stage"
	}
}
