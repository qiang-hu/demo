def labels = ['stag-jnlp-slave', 'prod-jnlp-slave']
def prod_branch = 'master'
def stag_branch = 'dev'

if (env.BRANCH_NAME ==  "${prod_branch}") {
    echo "curr $BRANCH_NAME"
    node('prod-jnlp-slave') {
        stage('Prepare') {
            echo "================"
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
			sh "kubectl apply -f k8s.yaml --recordd"
        }
        
        def msg = "部署失败，快去查看原因！！！"
        def jenkinsUrl = "${JENKINS_URL}"
        def imageUrl = "https://www.iconsdb.com/icons/preview/red/x-mark-3-xxl-2.png"
        if (currentBuild.currentResult == "SUCCESS"){
            imageUrl= "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon-2.png"
            msg ="发布成功，干得不错！，奖励一个鸡腿。"
        }
        dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${jenkinsUrl}",messageUrl:"${BUILD_URL}"       
    }
} else if (env.BRANCH_NAME ==  "${stag_branch}") {
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
} else {
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
        def msg = "部署失败，快去查看原因！！！"
        def jenkinsUrl = "${JENKINS_URL}"
        def imageUrl = "https://www.iconsdb.com/icons/preview/red/x-mark-3-xxl-2.png"
        if (currentBuild.currentResult == "SUCCESS"){
            imageUrl= "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon-2.png"
            msg ="发布成功，干得不错！，奖励一个鸡腿。"
        }
        dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${jenkinsUrl}",messageUrl:"${BUILD_URL}"       
    }
}


