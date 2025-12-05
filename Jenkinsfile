pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Target Environment')
    }
    stages {
        stage('Validate Parameters') {
            steps {
                echo "🚀 Deploying ALL 3 WARs to ${params.ENVIRONMENT} environment"
                echo "📁 Expected URLs:"
                echo "   http://192.168.154.131:8080/${params.ENVIRONMENT}-supermarket/"
                echo "   http://192.168.154.131:8080/${params.ENVIRONMENT}-sample/"
                echo "   http://192.168.154.131:8080/${params.ENVIRONMENT}-TestServerKrishna/"
            }
        }
        stage('Validate Files') {
            steps {
                sh '''
                    echo "✅ Checking multi-WAR deployment files..."
                    ls -la inventory-${ENVIRONMENT}.ini || (echo "❌ inventory-${ENVIRONMENT}.ini missing" && exit 1)
                    ls -la wars/supermarket.war wars/sample.war wars/TestServerKrishna.war || (echo "❌ WARs missing!" && exit 1)
                    ls -la deploy_tomcat.yml || (echo "❌ deploy_tomcat.yml missing" && exit 1)
                    echo "✅ All 3 WARs ready!"
                '''
            }
        }
        stage('Deploy to Environment') {
            steps {
                sh '''
                    ansible-playbook deploy_tomcat.yml \\
                        -i inventory-${ENVIRONMENT}.ini \\
                        -e env_prefix=${ENVIRONMENT} \\
                        -vvv
                '''
            }
        }
    }
    post {
        success {
            echo "🌟 Multi-WAR Deployment SUCCESSFUL to ${params.ENVIRONMENT}!"
        }
        failure {
            echo "❌ Deployment FAILED"
        }
    }
}


