pipeline {
  agent {
    label 'stag-jnlp-slave'
  }
  stages {
    stage('CleanWS') {
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
    stage('Prepare') {
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
    stage('Build') {
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
    stage('Push') {
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
    stage('Deploy') {
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
    stage('dd') {
      steps {
        dingTalk(accessToken: 'https://oapi.dingtalk.com/robot/send?access_token=d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724', jenkinsUrl: 'http://jenkins.ddtester.com')
      }
    }
  }
  environment {
    branch = 'dev'
  }
  post {
    always {
      script {
        def msg = "发布失败"
        def imageUrl = "https://www.iconsdb.com/icons/preview/red/x-mark-3-xxl.png"
        if (currentBuild.currentResult=="SUCCESS"){
          imageUrl= "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"
          msg ="发布成功，干得不错"
        }
        dingTalk accessToken:"https://oapi.dingtalk.com/robot/send?access_token=d5b6952bdd0b4755c47c47a3d024eacd3ed75956089761b27c9c89af1910d724",message:"${msg}",imageUrl:"${imageUrl}",messageUrl:"${BUILD_URL}"
      }


    }

  }
  options {
    disableConcurrentBuilds()
  }
}