pipeline {
    // 指定项目在label为jnlp-agent的节点上构建，也就是Jenkins Slave in Pod
    agent { label 'stag-jnlp-slave' }
    // 对应Do not allow concurrent builds
    options {
        disableConcurrentBuilds()
    }
        // 拉取
        stage ("Prepare"){
            steps {
                script {
                    try{
                        echo "1.Prepare Stage"
                        checkout scm
                        build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        if (env.BRANCH_NAME != 'master') {
                                build_tag = "${env.BRANCH_NAME}-${build_tag}"
                        }
                    }catch(err){
                        echo "${err}"
                        sh 'exit 1'
                    }
                }
            }
        }
} 
