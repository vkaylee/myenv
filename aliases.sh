#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
APPCONFIG_DIR="${MYENV_DIR}/appconfig"
# Load lib
source "${work_dir}/lib.sh"
# Alias for docker-compose
if [ "$(command -v docker-compose)" ]; then
    set_command_aliases 'docker-compose,dkc,docker compose' 'docker-compose' 'Docker compose'
else
    set_command_aliases 'docker-compose,dkc,docker compose' 'docker compose' 'Docker compose'
fi

# Some commands depend on docker cli and docker engine
if [ "$(command -v docker)" ]; then
    # AWS CLI
    # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    # Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file first
    # Test by running in a new console session: aws configure list
    if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" || -z "${AWS_DEFAULT_REGION}" ]]; then
        echo "Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file to use aws cli (amazon command line)"
    else
        set_command_aliases 'awscli,aws' 'docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION public.ecr.aws/aws-cli/aws-cli:latest' 'Amazon Web Service'
    fi

    # Add terraform
    set_command_aliases 'terraform,tf' "docker run --rm -ti --name terraform -w /workspace -v \$(pwd):/workspace -v ${APPCONFIG_DIR}/terraform:/root/.terraform.d hashicorp/terraform:latest" 'Infrastructure as code (IAC) tool'
    # Add google cloud cli
    set_command_aliases 'gcloud,gcli' "docker run --rm -ti --name gcloud -e CLOUDSDK_CONFIG=/config/mygcloud -v ${APPCONFIG_DIR}/google_cloud/mygcloud:/config/mygcloud -v ${APPCONFIG_DIR}/google_cloud:/certs gcr.io/google.com/cloudsdktool/google-cloud-cli gcloud" 'Google cloud command line tool'
    set_command_aliases 'gshell' 'gcloud cloud-shell ssh --authorize-session' 'Google cloud shell'
fi

# Add kubectl
KUBECONFIG_USER_DIR="${HOME}/.kube"
KUBECONFIG_DIR="${APPCONFIG_DIR}/kubeconfig"
## If the dir is not a symlink
if [ ! -h "${KUBECONFIG_USER_DIR}" ]; then
    # Copy to KUBECONFIG_DIR
    cp -a "${KUBECONFIG_USER_DIR}/*" "${KUBECONFIG_DIR}"
    # Remove
    rm -rf "${KUBECONFIG_USER_DIR}"
fi
# Create symlink
ln -sfn "${KUBECONFIG_DIR}" "${KUBECONFIG_USER_DIR}"

set_command_aliases 'kubectl,kctl' 'kubectl' 'Kubernetes command line interface'