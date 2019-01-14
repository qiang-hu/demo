def labels = ['stag-jnlp-slave', 'prod-jnlp-slave']
def prod_branch = 'master'
def stag_branch = 'dev'
def job_name = 'demo'

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
                        build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        // job_name = sh(returnStdout: true, script: "echo \${env.job_name}|awk -F '/' '{print \$1}'").trim()
                        // build_tag = "${env.BRANCH_NAME}-${git_commit}"
                    }
                }
                stage('Test') {
                    echo "2.Test Stage"
                }
                stage('Build') {
                    echo "3.Build Docker Image Stage"
                    sh "docker build -t harbor.ddtester.com/${job_name}/${env.BRANCH_NAME}:${build_tag} ."
                }
                stage('Push') {
                    echo "4.Push Docker Image Stage"
                    withCredentials([usernamePassword(credentialsId: 'Harbor', passwordVariable: 'HarborPassword', usernameVariable: 'HarborUser')]) {
                        sh "docker login -u ${HarborUser} -p ${HarborPassword} harbor.ddtester.com"
                        sh "docker push harbor.ddtester.com/${job_name}/${env.BRANCH_NAME}:${build_tag}"
                    }
                    // script {
                    //     def filename = 'chart/nginx/values.yaml'
                    //     def data = readYaml file: filename
                    //     data.image.tag = ${build_tag}
                    //     sh "rm $filename"
                    //     writeYaml file: filename, data: data
                    // }
                    // script {
                    //     def filename = 'chart/nginx/Chart.yaml'
                    //     def data = readYaml file: filename
                    //     data.version = ${build_tag}
                    //     sh "rm $filename"
                    //     writeYaml file: filename, data: data
                    // }
                }
                stage('Deploy') {
                    echo "5.Deploy Stage"
                    dir('chart') {
                        dir('php') {
                            withCredentials([usernamePassword(credentialsId: 'Harbor', passwordVariable: 'HarborPassword', usernameVariable: 'HarborUser')]) {
                                sh "helm init --client-only --skip-refresh"
                                sh "helm repo add myrepo  http://harbor.ddtester.com/chartrepo/helm"
                                // sh "helm repo add myrepo --username=${HarborUser} --password=${HarborPassword} http://harbor.ddtester.com/chartrepo/helm"
                                sh "sed -i 's/<BUILD_TAG>/${build_tag}/' values.yaml"
                                sh "sed -i 's/<BUILD_TAG>/${build_tag}/' Chart.yaml"
                                sh "sed -i 's/<JOB_NAME>/${job_name}/' values.yaml"
                                sh 'helm upgrade php --install  .'
                            }    
                        }
                        dir('nginx') {
                            withCredentials([usernamePassword(credentialsId: 'Harbor', passwordVariable: 'HarborPassword', usernameVariable: 'HarborUser')]) {
                                sh "helm init --client-only --skip-refresh"
                                sh "helm repo add myrepo  http://harbor.ddtester.com/chartrepo/helm"
                                // sh "helm repo add myrepo --username=${HarborUser} --password=${HarborPassword} http://harbor.ddtester.com/chartrepo/helm"
                                sh "sed -i 's/<BUILD_TAG>/${build_tag}/' values.yaml"
                                sh "sed -i 's/<BUILD_TAG>/${build_tag}/' Chart.yaml"
                                sh "sed -i 's/<JOB_NAME>/${job_name}/' values.yaml"
                                sh 'helm upgrade nginx --install  --set ingress.host=demo.ddtester.com .'
                        }
                    // sh "sed -i 's/<BUILD_TAG>/${build_tag}/' values.yaml"
                    // sh "sed -i 's/<job_name>/${job_name}/' values.yaml"
                    // withCredentials([usernamePassword(credentialsId: 'Harbor', passwordVariable: 'HarborPassword', usernameVariable: 'HarborUser')]) {
                    //     sh "helm repo add myrepo --username=${HarborUser} --password=${HarborPassword} http://harbor.ddtester.com/chartrepo/helm"
                    //     sh "helm upgrade"
                    //     sh "helm install myrepo/nginx --version ${build_tag} -f values.yaml"
                    // }
                    }
                }    
            }    
            notifySuccessful()
        } catch (err) {
            currentBuild.result = "FAILED"
            notifyFailed()
            throw err
            sh 'exit 1'
        }
    }                   
} 

def notifyStarted() { 
    def imageUrl= "http://img5q.duitang.com/uploads/blog/201504/21/20150421141329_kjNtm.thumb.224_0.gif"
    def msg ="状态:[工作启动]\n项目名称:${job_name}\n构建编号:[${env.BUILD_NUMBER}]"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"       
}

def notifySuccessful() { 
    def imageUrl= "http://img.xinxic.com/img/456dbe74031b1fbd.jpg"
    def msg ="[恭喜哦，部署成功。]\n项目名称:${job_name}\n构建编号:[${env.BUILD_NUMBER}]"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"               
}

def notifyFailed() { 
    def imageUrl= "http://img3.imgtn.bdimg.com/it/u=717988008,499956393&fm=26&gp=0.jpg"
    def msg ="状态:[部署失败了,快去检查日志！]\n项目名称:${job_name}\n构建编号:[${env.BUILD_NUMBER}]"
    dingTalk accessToken:"d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",jenkinsUrl:"${JENKINS_URL}",messageUrl:"${BUILD_URL}"               
} 

