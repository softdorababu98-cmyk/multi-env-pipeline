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

        stage('Validate Files') {
            steps {
                sh '''
                    echo "✅ Checking files..."
                    ls -la inventory-${ENVIRONMENT}.ini || (echo "❌ inventory-${ENVIRONMENT}.ini missing" && exit 1)
                    ls -la wars/${WAR_FILE} || (echo "❌ wars/${WAR_FILE} missing" && exit 1)
                    ls -la deploy_tomcat.yml || (echo "❌ deploy_tomcat.yml missing" && exit 1)
                    echo "✅ All files ready!"
                '''
            }
        }

        stage('Deploy to Environment') {
            steps {
                script {
                    def inventory_file = "inventory-${params.ENVIRONMENT}.ini"  // ← FIXED!
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
            echo "🏗️ Build ${currentBuild.currentResult} | Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        success {
            echo "✅ SUCCESS: ${params.WAR_FILE} deployed to ${params.ENVIRONMENT}!"
            echo "🌐 Access: http://192.168.154.131:8080/${params.ENVIRONMENT}-${params.WAR_FILE.replace('.war', '')}"
        }
        failure {
            echo "❌ FAILED: Check Ansible logs above"
            echo "🔍 Run manually: cd /var/lib/jenkins/jobs/multi-env-pipeline/workspace"
            echo "🔍 ansible-playbook deploy_tomcat.yml -i inventory-${params.ENVIRONMENT}.ini -vvv"
        }
    }
}

