pipeline {
    agent any

    environment {
        // Define any environment variables here
        ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository
                git branch: 'main', url: 'https://github.com/2020WB86391/Upgrade.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Install Ansible and other dependencies
                sh '''
                sudo apt update
                sudo apt install -y ansible
                '''
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                // Run the Ansible playbook to upgrade Ubuntu OS
                ansiblePlaybook(
                    playbook: 'upgrade.yml',
                    inventory: 'hosts',
                    colorized: true
                )
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

