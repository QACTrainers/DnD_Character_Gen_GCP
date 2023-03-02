pipeline{
                agent any
                environment {
                                IP=credentials('ip')
                                PWORD=credentials('password')
                        }
        stages{
                        stage('--Front End--'){
                                steps{
                                        sh '''
                                                image="eu.gcr.io/lbg-cloud-incubation/frontend"
                                                docker build -t $image:build-$BUILD_NUMBER -t $image:latest ./frontend
                                                docker push $image:build-$BUILD_NUMBER
                                                docker push $image:latest
                                        '''
                                }
                        }  
                        stage('--Service1--'){
                                steps{
                                        sh '''
                                                image="eu.gcr.io/lbg-cloud-incubation/rand1"
                                                docker build -t $image:build-$BUILD_NUMBER -t $image:latest ./randapp1
                                                docker push $image:build-$BUILD_NUMBER
                                                docker push $image:latest
                                        '''
                                }
                        }
                        stage('--Service2--'){
                                steps{
                                        sh '''
                                                image="eu.gcr.io/lbg-cloud-incubation/rand2"
                                                docker build -t $image:build-$BUILD_NUMBER -t $image:latest ./randapp2
                                                docker push $image:build-$BUILD_NUMBER
                                                docker push $image:latest
                                        '''
                                }
                        }
                        stage('--Back End--'){
                                steps{
                                        sh '''
                                                image="eu.gcr.io/lbg-cloud-incubation/backend"
                                                docker build -t $image:build-$BUILD_NUMBER -t $image:latest ./backend
                                                docker push $image:build-$BUILD_NUMBER
                                                docker push $image:latest
                                        '''
                                }
                        }
                        stage('--Deploy--'){
                                steps{
                                        sh '''
                                        cd ./kubernetes
                                        sed -e 's,{MYSQL_PWD},'$PWORD',g;' -e 's,{MYSQL_IP},'$IP',g;' ./secret/secrets.yaml | kubectl apply -f -
                                        kubectl apply -f .
                                        kubectl rollout restart deployment frontend
                                        kubectl rollout restart deployment backend
                                        kubectl rollout restart deployment service1
                                        kubectl rollout restart deployment service2
                                        '''
                                }
                        }
                }
        }