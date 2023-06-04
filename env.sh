#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
# Associate array to store env by key value, key is unique
typeset -A myenv_env_assarr_876892765834465872652357846459283659=()
# Array for storing all env file paths
myenv_env_file_paths_876892765834465872652357846459283659=()
myenv_read_envs_876892765834465872652357846459283659(){
  local filePath="${1-}"
  while read -r line; do
    echo "${line}"
  done <<< "$(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${filePath}")"
}
myenv_show_envs_876892765834465872652357846459283659(){
  local envLines=()
  # Take key value and format "key=value\n" for sorting
  for envKey envValue in "${(@kv)myenv_env_assarr_876892765834465872652357846459283659}"; do
    envLines+=( "${envKey}=${envValue}\n" )
  done

  # Print envLine
  local envCount=0
  myenv_lib_983459816_typing_style_print "Environment variables (ordered by key):"; printf "\n"
  while read -r envLine; do
    if [[ -n "${envLine}" ]]; then
      ((envCount++))
      myenv_lib_983459816_typing_style_print "- (${envCount}) ${envLine}"; printf "\n"
    fi
  done < <(echo -e "${envLines}" | sort -u -t '=' -k 1)

  # Print env file paths
  local envFileCount=0
  myenv_lib_983459816_typing_style_print "Envs are loaded from:"; printf "\n"
  for envPath in "${myenv_env_file_paths_876892765834465872652357846459283659[@]}" ; do
    if [[ -n "${envPath}" ]]; then
      ((envFileCount++))
      myenv_lib_983459816_typing_style_print "- (${envFileCount}) ${envPath}"; printf "\n"
    fi
  done
}
myenv_set_envs_876892765834465872652357846459283659(){
  local envFilePath=$1
  if [ -r "${envFilePath}" ]; then
    local envLines=()
    while read -r envLine; do
      # Add to envLines for sourcing
      envLines+=( "${envLine}" )
      # Take envKey value from envLine
      # Take envKey by regex
      envKey=$(echo "${envLine}" | grep -oP '^[^=]+')
      if [[ -n "${envKey}" ]]; then
        # Take value by removing the envKey
        # Set key value to myenv_env_assarr_876892765834465872652357846459283659
        myenv_env_assarr_876892765834465872652357846459283659["${envKey}"]="${envLine#"${envKey}="}"
      fi
    done < <(myenv_read_envs_876892765834465872652357846459283659 "${envFilePath}")
    set -a
    # shellcheck source=currentDir/.env
    if source <(echo -e "${envLines}"); then
      myenv_env_file_paths_876892765834465872652357846459283659+=("${envFilePath}")
    fi
    set +a
    myenv_lib_983459816_typing_style_print "Some environment variables in ${envFilePath} have been set!"
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