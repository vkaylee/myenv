#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
myenv_env_file_paths_876892765834465872652357846459283659=()
myenv_read_envs_876892765834465872652357846459283659(){
  local filePath="${1-}"
  while read -r line; do
    echo "${line}"
  done <<< "$(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${filePath}")"
}
myenv_show_envs_876892765834465872652357846459283659(){
  local linestr=""
  for envPath in "${myenv_env_file_paths_876892765834465872652357846459283659[@]}" ; do
    for myline in $(myenv_read_envs_876892765834465872652357846459283659 "${envPath}"); do
      if [[ -n "${linestr}" ]]; then
        linestr="${linestr}\n${myline}"
      else
        linestr="${myline}"
      fi
    done
  done

  local keys=()
  typeset -A assArr=()
  while read -r line
  do
    # Take key by regex
    key=$(echo "$line" | grep -oP '^[^=]+')
    if [[ -n "${key}" ]]; then
      # Take value by removing the key
      value=${line#"${key}="}
      # Add to keys if the key does not exist in assArr to keep the order
      if [[ -z "${assArr["${key}"]}" ]]; then
        keys+=( "${key}" )
      fi
      # Set key value to assArr
      assArr["${key}"]="${value}"
    fi
  done < <(echo -e "${linestr}" | sort -u -t '=' -k 1)

  # Loop order keys to take values
  for key in "${keys[@]}"; do
    lib_typing_style_print_983459816542476252 "${key}=${assArr["${key}"]}"
    printf "\n"
  done

  lib_typing_style_print_983459816542476252 "Envs are loaded from:"; printf "\n"
  for envPath in "${myenv_env_file_paths_876892765834465872652357846459283659[@]}" ; do
    lib_typing_style_print_983459816542476252 "- ${envPath}"; printf "\n"
  done
}
myenv_set_envs_876892765834465872652357846459283659(){
  local envFilePath=$1
  if [ -r "${envFilePath}" ]; then
    set -a
    # shellcheck source=currentDir/.env
    if source <(myenv_read_envs_876892765834465872652357846459283659 "${envFilePath}"); then
      myenv_env_file_paths_876892765834465872652357846459283659+=("${envFilePath}")
    fi
    set +a
    lib_typing_style_print_983459816542476252 "Some environments in ${envFilePath} have been set!" 0.005
    printf '\n'
  fi
}

# Load root ENV
myenv_set_envs_876892765834465872652357846459283659 "${work_dir}/.env"
# Custom ENV
## appconfig DIR
export MYENV_APPCONFIG_DIR="${MYENV_DIR}/appconfig"
## Kubectl
touch ${MYENV_APPCONFIG_DIR}/kubeconfig/config
export KUBECONFIG="${KUBECONFIG}:${MYENV_APPCONFIG_DIR}/kubeconfig/config"
# Load workspace ENV
myenv_set_envs_876892765834465872652357846459283659 "$(pwd)/.env.myenv"