#!/usr/bin/groovy


def withDocker(image, groovy.lang.Closure code) {
    retryWithDelay(3, 120, {
        sh "docker pull ${image}"
    })
    docker.image(image).inside("--entrypoint=''") {
        code()
    }
}

def withTerraform(groovy.lang.Closure code) {
    withDocker("hashicorp/terraform:light", code)
}

def withAWSCLI(groovy.lang.Closure code) {
    withDocker("harbor.h2o.ai/opsh2oai/awscli", code)
}

def internalH2ODockerLogin() {
    retryWithDelay(3, 120, {
        withCredentials([usernamePassword(credentialsId: "harbor.h2o.ai", usernameVariable: 'REGISTRY_USERNAME', passwordVariable: 'REGISTRY_PASSWORD')]) {
            sh "docker login -u $REGISTRY_USERNAME -p $REGISTRY_PASSWORD harbor.h2o.ai"
        }
    })
}

def terraformDestroy() {
    sh """
        terraform init
        terraform destroy -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -auto-approve
        """
}

def gitCommit(files, msg) {
    sh """
                git config --add remote.origin.fetch +refs/heads/${BRANCH_NAME}:refs/remotes/origin/${BRANCH_NAME}
                git fetch --no-tags
                git checkout ${BRANCH_NAME}
                git pull
                git add ${files.join(" ")}
                git config remote.origin.url "https://${GITHUB_TOKEN}@github.com/h2oai/sparkling-water.git"
                git commit -m "${msg}"
                git push --set-upstream origin ${BRANCH_NAME}
               """
}

def terraformApply() {
    sh """
        terraform init
        terraform apply -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -auto-approve
        """
}

def withAWSCredentials(code) {
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS S3 Credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        code()
    }
}

def withGit(code) {
    withCredentials([file(credentialsId: 'master-id-rsa', variable: 'ID_RSA_PATH'), file(credentialsId: 'master-gitconfig', variable: 'GITCONFIG_PATH'), string(credentialsId: 'h2o-ops-personal-auth-token', variable: 'GITHUB_TOKEN')]) {
        sh """
                # Copy keys
                rm -rf ~/.ssh
                mkdir -p ~/.ssh
                cp \${ID_RSA_PATH} ~/.ssh/id_rsa
                cp \${GITCONFIG_PATH} ~/.gitconfig
            """
        code()
    }
}

return this
