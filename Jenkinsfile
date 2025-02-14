// pipeline {
//     // --> install awscli, docker,kubectl
//     agent any  
//     // agent {
//     //     docker {
//     //         image 'node:lts-buster-slim'
//     //         args '-p 4000:3000'
//     //     }
//     // }
//     environment {
//         DOCKER_REGISTRY = 'chillakurulathasree'
//         DOCKER_IMAGE = "${DOCKER_REGISTRY}/react_with_node"
//         DOCKER_CREDENTIALS_ID = 'docker-cred'
         
//     }
//     stages {
//         stage('Checkout Code') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
//                     sh 'git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Lathasree487/simple-node-js-react-npm-app.git'
//                 }
//             }
//         }
//         stage('Docker Build') {
//             steps {
//                 script {
//                     docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
//                 }
//             }
//         }
//         stage('Publish to DockerHub') {
//             steps {
//                  script {
//                     docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
//                         docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push()
//                         docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push('latest')
//                     }
//                 }
//             }
//         }
//         stage('Deploy to EKS') {
//             steps {
//                 script {
//                     sh 'aws eks update-kubeconfig --name=Terraform-pipeline-EKS --region=us-east-1'
//                     sh 'kubectl apply -f k8s_manifest/namespace.yaml'
//                     sh 'kubectl apply -f k8s_manifest/deployment.yaml'
//                     sh 'kubectl apply -f k8s_manifest/service.yaml'
//                     // sh 'kubectl delete/apply -f k8s_manifest/namespace.yaml'
//                 }
//             }
//         }
//         stage('Send Notification') {
//             steps {
//                 mail to: 'lathasree487@gmail.com',
//                     subject: "Build ${env.BUILD_NUMBER} - ${currentBuild.currentResult} React App was Succesfull!",
//                     body: "The sample-node-js-React-npm-app was successfull \n\nBuild ${env.BUILD_NUMBER} is complete. \n\nStatus: ${currentBuild.currentResult}"
//             }
//         }
//     }
//     post {
//         always {
//             cleanWs() 
//         }
//     }
// }

pipeline {
    agent any

    environment {
        IMAGE_NAME = "chillakurulathasree/trivy"
        // IMAGE_TAG = "latest"
        DOCKER_CREDENTIALS_ID = 'docker-cred'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage("TRIVY"){
            steps{
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    sh "trivy image --no-progress --exit-code 1 --severity LOW,MEDIUM,HIGH,CRITICAL --format table ${IMAGE_NAME}:${env.BUILD_ID}"
                 }   
            }
        }

        // stage('Push Image to DockerHub') {
        //     when {
        //         expression {
        //             // Optional: only push if Trivy scan passed (no high or critical vulnerabilities)
        //             currentBuild.result == null
        //         }
        //     }
            stage('Publish to DockerHub') {
            steps {
                 script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        docker.image("${IMAGE_NAME}:${env.BUILD_ID}").push()
                        // docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push('latest')
                    }
                }
            }
        }
        }
    }
