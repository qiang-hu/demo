pipeline {
    // 指定项目在label为jnlp-agent的节点上构建，也就是Jenkins Slave in Pod
    agent { label 'prod-jnlp-slave' }
    // 对应Do not allow concurrent builds 
    options {
        disableConcurrentBuilds()
    }
    // ------ 以下内容无需修改 ------
    stages {
        // 拉取
        stage ("Prepare"){
            steps {
                checkout scm
                script {
                    try{
                        build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        build_tag = "${env.BRANCH_NAME}-${build_tag}"
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }
            }
        }
       // 测试
        stage ("Test"){
            steps {
                checkout scm
                script {
                    try{
			echo "2.Test Stage"
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }
            }
	}
       // 构建
        stage ("Build-stag"){ 
            when {
                branch 'dev'
            }
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
        stage ("Build-prod"){
            when {
                branch 'master'
            }
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
        stage ("Push-stag"){
            when {
                branch 'dev'
            }
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
        stage ("Push-prod"){
            when {
                branch 'master'
            }
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
        stage ("Deploy-stag"){
            when {
                branch 'dev'
            }
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
        stage ("Deploy-prod"){
            when {
                branch 'master'
            }
	    agent {
	    	label 'prod-jnlp-slave'
            }
            steps {
                script {
                    try{
                        sh "ls"
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }
            }
       } 
   }
}
