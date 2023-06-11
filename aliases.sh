#!/usr/bin/env zsh
# Some commands depend on docker cli and docker engine
if myenv_lib_983459816_has_command "docker"; then
    # Alias for docker-compose
    if myenv_lib_983459816_has_command "docker-compose"; then
        myenv_lib_983459816_set_command_aliases 'docker compose,docker-compose,dkc' 'docker-compose' 'Docker compose'
    elif myenv_lib_983459816_has_command "docker compose"; then
        myenv_lib_983459816_set_command_aliases 'docker compose,docker-compose,dkc' 'docker compose' 'Docker compose'
    fi
    # AWS CLI
    # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    # Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file first
    # Test by running in a new console session: aws configure list
    if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" || -z "${AWS_DEFAULT_REGION}" ]]; then
        echo "Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file to use aws cli (amazon command line)"
    else
        myenv_lib_983459816_set_command_aliases 'awscli,aws' 'myenv_lib_983459816-docker_exec public.ecr.aws/aws-cli/aws-cli:latest -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION ::end_docker::' 'Amazon Web Service'
    fi

    # Add terraform
    myenv_lib_983459816_set_command_aliases 'terraform,tf' "myenv_lib_983459816-docker_exec hashicorp/terraform:latest --name terraform -w /workspace -v \$(pwd):/workspace -v ${MYENV_APPCONFIG_DIR}/terraform:/root/.terraform.d ::end_docker::" 'Infrastructure as code (IAC) tool'
    # Add google cloud cli
    myenv_lib_983459816_set_command_aliases 'gcloud,gcli' "myenv_lib_983459816-docker_exec gcr.io/google.com/cloudsdktool/google-cloud-cli --name gcloud -e CLOUDSDK_CONFIG=/config/mygcloud -v ${MYENV_APPCONFIG_DIR}/google_cloud/mygcloud:/config/mygcloud -v ${MYENV_APPCONFIG_DIR}/google_cloud:/certs ::end_docker:: gcloud" 'Google cloud command line tool'
    myenv_lib_983459816_set_command_aliases 'gshell' 'gcloud cloud-shell ssh --authorize-session' 'Google cloud shell'
    myenv_lib_983459816_set_command_aliases 'flyctl,flyio,fly' "myenv_lib_983459816-docker_exec flyio/flyctl --name flyio -v ${MYENV_APPCONFIG_DIR}/flyio:/.fly ::end_docker::" 'Fly is a platform for running full stack apps and databases close to your users'
    # Add mitmproxy
    MITMPROXYD='MITM_PORT=${MITM_PORT:-8080} && MITM_WEB_PORT=${MITM_WEB_PORT:-8081} && '
    MITMPROXYD=${MITMPROXYD}'MITM_PORT=$(myenv_lib_983459816_take_unuse_port $MITM_PORT) && MITM_WEB_PORT=$(myenv_lib_983459816_take_unuse_port $MITM_WEB_PORT) && '
    MITMPROXYD=${MITMPROXYD}'myenv_lib_983459816-docker_exec mitmproxy/mitmproxy -v ${MYENV_APPCONFIG_DIR}/mitmproxy:/home/mitmproxy/.mitmproxy -p ${MITM_PORT}:${MITM_PORT} -p ${MITM_WEB_PORT}:${MITM_WEB_PORT} ::end_docker::'
    myenv_lib_983459816_set_command_aliases 'mitmproxy,mitmp' ${MITMPROXYD}' mitmproxy -p ${MITM_PORT}' 'a man-in-the-middle proxy with a command-line interface'
    myenv_lib_983459816_set_command_aliases 'mitmdump,mitmd' ${MITMPROXYD}' mitmdump -p ${MITM_PORT}' 'mitmdump is the command-line companion to mitmproxy'
    myenv_lib_983459816_set_command_aliases 'mitmweb,mitmw' ${MITMPROXYD}' mitmweb -p ${MITM_PORT} --web-host 0.0.0.0 --web-port ${MITM_WEB_PORT}' 'a man-in-the-middle proxy with a web interface'
fi

# Add kubectl
myenv_lib_983459816_set_command_aliases 'kubectl,kctl' 'kubectl' 'Kubernetes command line interface'