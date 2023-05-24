#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
# Load lib
source "${work_dir}/lib.sh"
# Alias for docker-compose
set_command_alias 'gshell' 'gcloud cloud-shell ssh --authorize-session'
set_command_alias 'docker-compose' 'docker compose'
set_command_alias 'dkc' 'docker-compose'
# Some commands depend on docker cli and docker engine
if [ "$(command -v docker)" ]; then
    # AWS CLI
    # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    # Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file first
    # Test by running in a new console session: aws configure list
    if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" || -z "${AWS_DEFAULT_REGION}" ]]; then
        echo "Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION in .env file to use aws cli (amazon command line)"
    else
        set_command_alias 'aws' 'docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION public.ecr.aws/aws-cli/aws-cli:latest'
    fi

    # Add terraform
    set_command_alias 'terraform' "docker run --rm -ti --name terraform -w /workspace -v \$(pwd):/workspace -v ${work_dir}/appconfig/terraform:/root/.terraform.d hashicorp/terraform:latest"
    set_command_alias 'tf' 'terraform'
fi
