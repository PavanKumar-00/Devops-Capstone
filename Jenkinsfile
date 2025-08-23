pipeline {
  agent any
  environment {
    DOCKERHUB = credentials('dockerhub-creds')
    DOCKER_IMAGE = "pavankuamr000/capstone-app"
    KUBE_NAMESPACE = "capstone"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
      }
    }
    stage('Login & Push') {
      steps {
        sh 'echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin'
        sh 'docker push $DOCKER_IMAGE:$BUILD_NUMBER'
        sh 'docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest'
        sh 'docker push $DOCKER_IMAGE:latest'
      }
    }
    stage('Deploy to EKS') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-capstone', variable: 'KUBECONFIG_FILE')]) {
          sh '''
            mkdir -p $WORKSPACE/.kube
            cp $KUBECONFIG_FILE $WORKSPACE/.kube/config
            export KUBECONFIG=$WORKSPACE/.kube/config

            kubectl apply -f k8s/namespace.yaml
            sed "s|IMAGE_PLACEHOLDER|$DOCKER_IMAGE:$BUILD_NUMBER|g" k8s/deployment.yaml | kubectl apply -n $KUBE_NAMESPACE -f -
            kubectl apply -n $KUBE_NAMESPACE -f k8s/service.yaml
          '''
        }
      }
    }
  }
  post {
    always { sh 'docker logout || true' }
  }
}
