pipeline {
    agent any
    
    parameters {
        choice(
            name: 'ENVIRONMENT', 
            choices: ['dev', 'test', 'prod'], 
            description: 'Target Environment'
        )
        choice(
            name: 'WAR_FILE', 
            choices: ['supermarket.war', 'TestServerKrishna.war', 'sample.war'], 
            description: 'WAR File to Deploy'
        )
    }
    
    stages {
        stage('Validate Parameters') {
            steps {
                echo "🚀 Deploying ${params.WAR_FILE} to ${params.ENVIRONMENT} environment"
                echo "📁 Expected URL: http://192.168.154.131:8080/${params.ENVIRONMENT}-${params.WAR_FILE.replace('.war', '')}"
            }
        }
        
        stage('Deploy to Environment') {
            steps {
                script {
                    def inventory_file = "${params.ENVIRONMENT}.ini"
                    def target_group = "${params.ENVIRONMENT}_servers"
                    
                    sh """
                        ansible-playbook deploy_tomcat.yml \\
                          -i ${inventory_file} \\
                          --limit ${target_group} \\
                          -e target_group=${target_group} \\
                          -e env_prefix=${params.ENVIRONMENT} \\
                          -e war_file=${params.WAR_FILE} \\
                          -vvv
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo "🏗️  Build ${currentBuild.currentResult} | Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        success {
            echo "✅ SUCCESS: ${params.WAR_FILE} deployed to ${params.ENVIRONMENT}!"
            echo "🌐 Access: http://192.168.154.131:8080/${params.ENVIRONMENT}-${params.WAR_FILE.replace('.war', '')}"
        }
        failure {
            echo "❌ FAILED: Check Ansible logs above"
        }
    }
}
