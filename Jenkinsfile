pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'test', 'prod'],
            description: 'Target Environment'
        )
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
                    ls -la wars/*.war || (echo "❌ WARs missing in workspace/wars/" && exit 1)
                    ls -la deploy_tomcat.yml || (echo "❌ deploy_tomcat.yml missing" && exit 1)
                    echo "✅ All 3 WARs ready for deployment!"
                '''
            }
        }

        stage('Deploy to Environment') {
            steps {
                ansiblePlaybook(
                    playbook: 'deploy_tomcat.yml',
                    inventory: "inventory-${params.ENVIRONMENT}.ini",
                    extraVars: [
                        env_prefix: params.ENVIRONMENT
                    ]
                )
            }
        }
    }

    post {
        success {
            echo "🌟 Multi-WAR Deployment SUCCESSFUL to ${params.ENVIRONMENT}!"
            sh '''
                echo "🔍 Verify deployment:"
                ssh root@192.168.154.131 "ls -la /opt/tomcat9/webapps/${ENVIRONMENT}-*.war"
                echo "🌐 Test URLs:"
                echo "   curl http://192.168.154.131:8080/${ENVIRONMENT}-supermarket/"
            '''
        }
        failure {
            echo "❌ Deployment FAILED - Check Ansible logs above"
            echo "🔍 Manual test: ansible-playbook deploy_tomcat.yml -i inventory-${ENVIRONMENT}.ini -e env_prefix=${ENVIRONMENT} -vvv"
        }
    }
}

