//properties([parameters([choice(name: 'CHOICES', choices: ['master', 'dev', 'huqiang'], description: '')])])
def branches = ['master', 'dev']
def labels = ['stag-jnlp-slave', 'prod-jnlp-slave']
if (env.BRANCH_NAME ==  'branches["dev"]') {
    echo "curr $BRANCH_NAME"
    node('stag-jnlp-slave') {
        stage('Prepare') {
            echo "1.Prepare Stage"
            checkout scm
            script {
                build_commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                build_tag = "${env.BRANCH_NAME}-${build_commit}"
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
            echo "5.Deploy Stage"
            sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        	sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
			sh "kubectl apply -f k8s.yaml --record"
        }
    }    
}else if (env.BRANCH_NAME ==  'branches["master"]') {
    echo "curr $BRANCH_NAME"
    node('prod-jnlp-slave') {
        stage('Prepare') {
            echo "1.Prepare Stage"
            checkout scm
            script {
                build_commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                build_tag = "${env.BRANCH_NAME}-${build_commit}"
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
            echo "5.Deploy Stage"
            sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        	sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
			sh "kubectl apply -f k8s.yaml --record"
        }
    }    
}
}else{
    echo "curr $BRANCH_NAME"
    node('stag-jnlp-slave') {
        stage('Prepare') {
            echo "1.Prepare Stage"
            checkout scm
            script {
                build_commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                build_tag = "${env.BRANCH_NAME}-${build_commit}"
            }
        }
        stage('Test') {
            echo "2.Test Stage"
        }
    }    
}
