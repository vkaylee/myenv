#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
myenv_set_envs_876892765834465872652357846459283659(){
  local envFilePath=$1
  if [ -r "${envFilePath}" ]; then
    set -a
    # shellcheck source=currentDir/.env
    source <(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${envFilePath}")
    set +a
    echo "Some environments in ${envFilePath} have been set!"
  fi
}

# Load root ENV
myenv_set_envs_876892765834465872652357846459283659 "${work_dir}/.env"
# Custom ENV
## appconfig DIR
export MYENV_APPCONFIG_DIR="${MYENV_DIR}/appconfig"
## Kubectl
export KUBECONFIG="${KUBECONFIG}:${MYENV_APPCONFIG_DIR}/kubeconfig/config"
# Load workspace ENV
myenv_set_envs_876892765834465872652357846459283659 "$(pwd)/.env.myenv"