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
        stage('Run Ansible Playbook') {
            steps {
                // Run the Ansible playbook to upgrade Ubuntu OS
                ansiblePlaybook(
                    colorized: true,
                    playbook: 'upgrade.yml',
                    inventory: 'hosts'
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

