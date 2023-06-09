#!/usr/bin/env zsh
# Alias for docker-compose
if [ "$(command -v docker-compose)" ]; then
    myenv_lib_983459816_set_command_aliases 'docker-compose,dkc,docker compose' 'docker-compose' 'Docker compose'
else
    myenv_lib_983459816_set_command_aliases 'docker-compose,dkc,docker compose' 'docker compose' 'Docker compose'
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
        myenv_lib_983459816_set_command_aliases 'awscli,aws' 'docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION public.ecr.aws/aws-cli/aws-cli:latest' 'Amazon Web Service'
    fi

    # Add terraform
    myenv_lib_983459816_set_command_aliases 'terraform,tf' "docker run --rm -ti --name terraform -w /workspace -v \$(pwd):/workspace -v ${MYENV_APPCONFIG_DIR}/terraform:/root/.terraform.d hashicorp/terraform:latest" 'Infrastructure as code (IAC) tool'
    # Add google cloud cli
    myenv_lib_983459816_set_command_aliases 'gcloud,gcli' "docker run --rm -ti --name gcloud -e CLOUDSDK_CONFIG=/config/mygcloud -v ${MYENV_APPCONFIG_DIR}/google_cloud/mygcloud:/config/mygcloud -v ${MYENV_APPCONFIG_DIR}/google_cloud:/certs gcr.io/google.com/cloudsdktool/google-cloud-cli gcloud" 'Google cloud command line tool'
    myenv_lib_983459816_set_command_aliases 'gshell' 'gcloud cloud-shell ssh --authorize-session' 'Google cloud shell'
    myenv_lib_983459816_set_command_aliases 'flyctl,flyio,fly' "docker run --rm -ti --name flyio -v ${MYENV_APPCONFIG_DIR}/flyio:/.fly flyio/flyctl" 'Fly is a platform for running full stack apps and databases close to your users'
    # Add mitmproxy
    MITMPROXYD='MITM_PORT=${MITM_PORT:-8080} && MITM_WEB_PORT=${MITM_WEB_PORT:-8081} && '
    MITMPROXYD=${MITMPROXYD}'MITM_PORT=$(myenv_lib_983459816_take_unuse_port $MITM_PORT) && MITM_WEB_PORT=$(myenv_lib_983459816_take_unuse_port $MITM_WEB_PORT) && '
    MITMPROXYD=${MITMPROXYD}'docker run --rm -it -p ${MITM_PORT}:${MITM_PORT} -p ${MITM_WEB_PORT}:${MITM_WEB_PORT} mitmproxy/mitmproxy'
    myenv_lib_983459816_set_command_aliases 'mitmproxy,mitmp' ${MITMPROXYD}' mitmproxy -p ${MITM_PORT}' 'a man-in-the-middle proxy with a command-line interface'
    myenv_lib_983459816_set_command_aliases 'mitmdump,mitmd' ${MITMPROXYD}' mitmdump -p ${MITM_PORT}' 'mitmdump is the command-line companion to mitmproxy'
    myenv_lib_983459816_set_command_aliases 'mitmweb,mitmw' ${MITMPROXYD}' mitmweb -p ${MITM_PORT} --web-host 0.0.0.0 --web-port ${MITM_WEB_PORT}' 'a man-in-the-middle proxy with a web interface'
fi

# Add kubectl
myenv_lib_983459816_set_command_aliases 'kubectl,kctl' 'kubectl' 'Kubernetes command line interface'