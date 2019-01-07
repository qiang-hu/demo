pipeline {
    // 指定项目在label为jnlp-agent的节点上构建，也就是Jenkins Slave in Pod
    agent { label 'stag-jnlp-slave' } 
    // 对应Do not allow concurrent builds 
    options {
        disableConcurrentBuilds()
    }
    environment { 
        // branch: 分支，一般是dev、 master，对应git从哪个分支拉取代码，也对应究竟执行_deploy文件夹下的dev配置还是master配置
        branch = "huqiang"
    }
    // ------ 以下内容无需修改 ------
    stages {
         // 开始构建前清空工作目录
         stage ("CleanWS"){ 
            steps {
                script {
                    try{
                       deleteDir()
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }  
            }  
        }
        // 拉取
        stage ("CheckOut"){ 
            steps {
                script {
                    try{
                      checkout([$class: 'GitSCM', branches: [[name: "*/${branch}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'gitlab', url: "${git}"]]])
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }  
            }  
        }
       // 构建
        stage ("Build"){ 
            steps {
                script {
                    try{
                        // 登录 harbor 
                        // 根据分支，进入_deploy下对应的不同文件夹，通过dockerfile打包镜像
			sh "docker build -t shansongxian/jenkins-demo:${build_tag} ."
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }  
            }  
        }
        stage ("Push"){
            steps {
                script {
                    try{
        		withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'DockerHubPassword', usernameVariable: 'DockerHubUser')]) {
            		sh "docker login -u ${DockerHubUser} -p ${DockerHubPassword}"
            		sh "docker push shansongxian/jenkins-demo:${build_tag}"
			}
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }   
            }
        }
        // 使用pipeline script中复制的变量替换deployment.yaml中的占位变量，执行deployment.yaml进行部署
        stage ("Deploy"){
            steps {
                script {
                    try{
        		sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        		sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
			sh "kubectl apply -f k8s.yaml --record"
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }
            }
        }
    }
    post {
        // 使用钉钉插件进行通知
        always {
            script {   
                def msg = "发布失败！"
                def imageUrl = "https://www.iconsdb.com/icons/preview/red/x-mark-3-xxl.png"
                if (currentBuild.currentResult=="SUCCESS"){
                    imageUrl= "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"
                    msg ="发布成功，干得不错！"
                }
                dingTalk accessToken:"https://oapi.dingtalk.com/robot/send?access_token=d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",messageUrl:"${BUILD_URL}"
            }
        }
    }
