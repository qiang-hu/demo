    options {
        disableConcurrentBuilds()
	buildDiscarder(logRotator(numToKeepStr: '10'))
	skipDefaultCheckout()
    }
    parameters {
       choice(name: 'CHOICES', choices: ['master', 'dev', 'huqiang'], description: '') 
    }
node('stag-jnlp-slave') {
    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            if (env.BRANCH_NAME != 'master') {
                build_tag = "${env.BRANCH_NAME}-${build_tag}"
            }
        }
    }
    stage('Test') {
      echo "2.Test Stage"
	}
}
