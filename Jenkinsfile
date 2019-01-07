node('stag-jnlp-slave') {
    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            if (env.BRANCH_NAME == 'master' && env.BRANCH_NAME == 'dev') {
                build_tag = "${env.BRANCH_NAME}-${build_tag}"
	    } else {
	      	echo "not master and dev branch exit 0"
		exit 0
            }
        }
    }
    stage('Test') {
      echo "2.Test Stage"
    }
    stage('Build') {
        echo "3.Build Docker Image Stage"
        sh "docker build -t shansongxian/jenkins-demo:${build_tag} ."
    }
    stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'DockerHubPassword', usernameVariable: 'DockerHubUser')]) {
            sh "docker login -u ${DockerHubUser} -p ${DockerHubPassword}"
            sh "docker push shansongxian/jenkins-demo:${build_tag}"
        }
    }
    stage('Deploy') {
        echo "5. Deploy Stage"
        when {
            branch "dev"
        }
        steps {
            sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
            sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
            sh "kubectl apply -f k8s.yaml --record"
        }    
    }
}
