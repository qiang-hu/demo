properties([parameters([choice(name: 'CHOICES', choices: ['master', 'dev', 'huqiang'], description: '')])])
def branches = ['master', 'dev']
def labels = ['stag-jnlp-slave', 'prod-jnlp-slave']
if (env.BRANCH_NAME ==  branches["master"]) {
	echo "$BRANCH_NAME"	
}
node('stag-jnlp-slave') {
    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            if (env.BRANCH_NAME != '${params.CHOICES}') {
		echo "curr $BRANCH_NAME"
            }
        }
    }
    stage('Test') {
      echo "2.Test Stage"
	}
}
