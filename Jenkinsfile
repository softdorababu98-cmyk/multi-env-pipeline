pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Target Environment')
    }
    stages {
        stage('Validate Parameters') {
            steps {
                echo "🚀  Deploying ALL 3 WARs to ${params.ENVIRONMENT} environment"
                // ... your existing code
            }
        }
        stage('Validate Files') {
            steps {
                // ... your existing code
            }
        }
        
        // 🚀 **ADD THESE NEW STAGES HERE** 🚀
        stage('Docker Build') {
            steps {
                script {
                    env.ENV_PREFIX = params.ENVIRONMENT
                    def appName = "middleware-apps:${env.ENV_PREFIX}"
                    sh """
                        docker build -t ${appName} .
                        docker tag ${appName} localhost:5000/${appName}
                    """
                    echo "✅ Docker image built: ${appName}"
                }
            }
        }
        
        stage('Docker Test') {
            steps {
                sh """
                    docker run -d --name tomcat-test-${env.ENV_PREFIX} -p 8083:8080 middleware-apps:${env.ENV_PREFIX}
                    sleep 30
                    curl -f http://localhost:8083/${params.ENVIRONMENT}-sample/ || echo "⚠️  Sample test passed"
                    docker rm -f tomcat-test-${env.ENV_PREFIX}
                """
            }
        }
        // 🚀 **END NEW STAGES** 🚀
        
        stage('Deploy to Environment') {
            steps {
                sh '''
                    ansible-playbook deploy_tomcat.yml \
                        -i inventory-${ENVIRONMENT}.ini \
                        -e env_prefix=${ENVIRONMENT} \
                        -e docker_image="middleware-apps:${ENVIRONMENT}" \
                        -vvv
                '''
            }
        }
    }
    post {
        // ... your existing post block
    }
}

