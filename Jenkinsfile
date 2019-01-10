pipeline {
    // 指定项目在label为jnlp-agent的节点上构建，也就是Jenkins Slave in Pod
    agent { label 'prod-jnlp-slave' }
    // 对应Do not allow concurrent builds 
    options {
	//不允许并行执行Pipeline,可用于防止同时访问共享资源
        disableConcurrentBuilds()
	//pipeline保持构建的最大个数
	buildDiscarder(logRotator(numToKeepStr: '10'))
	//默认跳过来自源代码控制的代码
	skipDefaultCheckout()
    }
    triggers {
        cron('* * * * *')
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
   }
}
