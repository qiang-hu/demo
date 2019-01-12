def labels = ['stag-jnlp-slave', 'prod-jnlp-slave']
def prod_branch = 'master'
def stag_branch = 'dev'

if (env.BRANCH_NAME ==  "${prod_branch}") {
    echo "curr $BRANCH_NAME"
    node('prod-jnlp-slave') {
        try {
            notifyStarted()
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
                    sh "kubectl apply -f k8s.yaml --record"
                }
            notifySuccessful()
        } catch (err) {
            currentBuild.result = "FAILED"
            notifyFailed()
            throw err
            sh 'exit 1'
        }
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
    }
}

def notifyStarted() { 
    def imageUrl= "http://img3.imgtn.bdimg.com/it/u=1018573270,2016126815&fm=26&gp=0.jpg"
    def msg ="状态:[工作启动] \n项目名称:'${env.JOB_NAME}\n构建编号:[${env.BUILD_NUMBER}]'"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"       
}

def notifySuccessful() { 
    def imageUrl= "http://img.xinxic.com/img/456dbe74031b1fbd.jpg"
    def msg ="\t[恭喜哦，部署成功。] \n项目名称:'${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"               
}

def notifyFailed() { 
    def imageUrl= "http://img3.imgtn.bdimg.com/it/u=717988008,499956393&fm=26&gp=0.jpg"
    def msg ="状态:[部署失败了,快去检查日志！]\n项目名称:'${env.JOB_NAME}\n构建编号[${env.BUILD_NUMBER}]'"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"               
} 

