#!/usr/bin/env zsh
# Namespace: start with myenv_lib_983459816_ and end with
myenv_lib_983459816_set_color(){
  local text="${1}"
  local colorCode="${2-"1;31"}"
  # Colors for text:
    # Black        0;30     Dark Gray     1;30
    # Red          0;31     Light Red     1;31
    # Green        0;32     Light Green   1;32
    # Brown/Orange 0;33     Yellow        1;33
    # Blue         0;34     Light Blue    1;34
    # Purple       0;35     Light Purple  1;35
    # Cyan         0;36     Light Cyan    1;36
    # Light Gray   0;37     White         1;37
  # For a colored background: Color text + 10
  # Example: "\e[1;31m This is red text \e[0m"
  # Refer: https://en.wikipedia.org/wiki/ANSI_escape_code
  local escapeString="\e[${colorCode}m"
  # Print out with escape 
  echo -e "${escapeString}${text}\e[0m"
}

# Define an array to store all guideline about all aliases
myenv_lib_983459816_alias_array=()

myenv_lib_983459816_typing_style_print(){
  local my_print_text="${1-}"
  local typing_speed="${2-0.0005}"
  for ((i=0; i<=${#my_print_text}; i++)); do
      printf '%s' "${my_print_text:$i:1}"
      sleep "${typing_speed}"
  done
}
myenv_lib_983459816_array_printer(){
  # 1: "${myArray[@]}"
  local myArray=("$@")
  for item in "${myArray[@]}";do
    myenv_lib_983459816_typing_style_print "- ${item}" 0.00025
    printf '\n'
    sleep 0.05
  done
}

myenv_lib_983459816_set_alias_array(){
  local value="${1-}"
  if [ -n "${value}" ]; then
    myenv_lib_983459816_alias_array+=("${value}")
  fi
}
myenv_lib_983459816_print_alias_array(){
  myenv_lib_983459816_array_printer "${myenv_lib_983459816_alias_array[@]}"
}
# This function is used to check the existent command or not
myenv_lib_983459816_has_command(){
  # Usage: myenv_lib_983459816_has_command <command_name>
  # Check whether a command exists
  # $1 the actual command you want to check
  local command="${1}"
  if grep -P '\s' <(echo "${command}") 1>/dev/null; then
    eval "${command}" >/dev/null 2>&1
    return $?
  fi
  # Aliases included by option -v
  command -v "${command}" >/dev/null 2>&1
  return $?
}
myenv_lib_983459816_set_alias_command(){
  # Input:
  # $1: The alias command that you want to register
  # $2: The command string
  # Return:
  # 0: set ok
  # 1: set failed
  local aliasCommand=$1
  local realCommand=$2
  # Allow if alias command is equal with real command
  if [[ "${aliasCommand}" == "${realCommand}" ]]; then
    return 0
  fi
  
  if ! myenv_lib_983459816_has_command "${aliasCommand}" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}

myenv_lib_983459816_set_command_aliases(){
  local aliases=$1
  local realCommand=$2
  local description=$3
  local directedShow="${4:-false}"

  local aliasCommands=(${(@s:,:)aliases})

  local okAliasesStr=()
  local noOkAliasesStr=()
  local delimiter=','

  # the first array index is different among shell
  local firstArrayIndex
  # default first index is zero
  firstArrayIndex=0
  # For zsh: first index is 1
  test "$ZSH_VERSION" && firstArrayIndex=1
  
  for ((i=${firstArrayIndex}; i < ${#aliasCommands[@]} + ${firstArrayIndex}; i++)); do
    # Just set real command to the first alias, the first alias will be set to aliases from the second if have
    if (( i > ${firstArrayIndex} )); then
      realCommand="${aliasCommands[firstArrayIndex]}"
    fi
    
    local commandTextStyle="$(myenv_lib_983459816_set_color "${aliasCommands[i]}" '1;92')"
    if myenv_lib_983459816_set_alias_command "${aliasCommands[i]}" "${realCommand}" > /dev/null 2>&1; then
      if [[ -n "${okAliasesStr}" ]]; then
        okAliasesStr="${okAliasesStr}${delimiter}${commandTextStyle}"
      else
        okAliasesStr="${commandTextStyle}"
      fi
    else
      if [[ -n "${noOkAliasesStr}" ]]; then
        noOkAliasesStr="${noOkAliasesStr}${delimiter}${commandTextStyle}"
      else
        noOkAliasesStr="${commandTextStyle}"
      fi
    fi
  done

  local retStr="${description}:"
  if [[ -n "${okAliasesStr}" ]]; then
    retStr="${retStr} ${okAliasesStr}"
  fi
  if [[ -n "${noOkAliasesStr}" ]]; then
    retStr="${retStr} (Can't register: ${noOkAliasesStr})"
  fi
  if $directedShow ; then
    myenv_lib_983459816_typing_style_print "${retStr}" 0.005
    printf "\n"
  else
    myenv_lib_983459816_set_alias_array "${retStr}"
  fi
}

myenv_lib_983459816_confirm()
{
  read -r input
  case "${input}" in
    [Yy]* ) return 0;;
    * ) return 1;;
  esac
}

myenv_lib_983459816_update(){
  local isManual=${1-false}
  local gitDir="${MYENV_DIR}/.git"
  local gitRemoteName="origin"
  local gitRemoteBranch="main"
  # Set origin url to make sure we have the right remote url
  git --git-dir="${gitDir}" remote set-url "${gitRemoteName}" https://github.com/vleedev/myenv.git

  if git --git-dir="${gitDir}" fetch "${gitRemoteName}" > /dev/null 2>&1; then
    local remoteLastCommit="$(git --git-dir="${gitDir}" rev-parse --short ${gitRemoteName}/${gitRemoteBranch})"
    local localLastCommit="$(git --git-dir="${gitDir}" rev-parse --short HEAD)"
    if [ "${remoteLastCommit}" != "${localLastCommit}" ]; then
      myenv_lib_983459816_typing_style_print "MYENV is having an update, do you want to update (y/n)? "
      if myenv_lib_983459816_confirm; then
        git --git-dir="${gitDir}" pull "${gitRemoteName}" "${gitRemoteBranch}"
        git --git-dir="${gitDir}" checkout "${gitRemoteName}/${gitRemoteBranch}"
        exec "${SHELL}"
      else
        myenv_lib_983459816_typing_style_print "Disable auto update by adding MYENV_AUTOUPDATE=false to your env file"
        printf "\n"
      fi
    else
      if ${isManual}; then
        # Check for MYENV_VERSION
        if [[ "${remoteLastCommit}" != "${MYENV_VERSION}" ]]; then
          myenv_lib_983459816_typing_style_print "Restart your shell ${SHELL}"; printf "\n"
          # Restart shell
          exec "${SHELL}"
        fi
        
        myenv_lib_983459816_typing_style_print "myenv is up to date, version: ${MYENV_VERSION}"; printf "\n"
      fi
    fi
  fi
}

# TODO: check more with every tcp and udp, ipv4 and ipv6
# We don't allow to run parallel by using myenv_lib_983459816_allocated_ports_mylock
myenv_lib_983459816_allocated_ports_mylock=$(mktemp)
myenv_lib_983459816_allocated_ports_file=$(mktemp)
myenv_lib_983459816_allocated_ports=()
typeset myenv_lib_983459816_allocated_ports > ${myenv_lib_983459816_allocated_ports_file}
myenv_lib_983459816_take_unuse_port() {
  # Read myenv_lib_983459816_allocated_ports_mylock
  # Lock until released
  while true; do
      if [[ -z "$(cat $myenv_lib_983459816_allocated_ports_mylock)" ]]; then
          echo 1 > ${myenv_lib_983459816_allocated_ports_mylock}
          break
      fi
      continue
  done
  # Body function
  # Load myenv_lib_983459816_allocated_ports
  source ${myenv_lib_983459816_allocated_ports_file}
  local defaultPort=${1:-}
  local sockets=$(ss -lntpu | awk '{ print $5 }')
  local returnPort=
  # Check for default port
  if [[ -n "${defaultPort}" ]]; then
    if ! grep -w ":${defaultPort}$" <(echo ${sockets}) > /dev/null 2>&1; then
      returnPort="${defaultPort}"
    fi
  fi
  if [[ -z "${returnPort}" ]]; then
    for port in {$(awk '{ print $1 }' /proc/sys/net/ipv4/ip_local_port_range)..$(awk '{ print $2 }' /proc/sys/net/ipv4/ip_local_port_range)};do
      if ! grep -w ":${port}$" <(echo ${sockets}) > /dev/null 2>&1; then
        # When the port does not exist in sockets
        # Check allocated ports
        if [[ ${myenv_lib_983459816_allocated_ports[(ie)$port]} -le ${#myenv_lib_983459816_allocated_ports} ]]; then
          # port exists in the myenv_lib_983459816_allocated_ports
          # Continue to check other ports in range
          continue
        fi
        # The port does not exist in myenv_lib_983459816_allocated_ports
        # Set it to returnPort
        returnPort="${port}"
        # Break the loop when having port
        break
      fi
    done
  fi
  
  if [[ -n "${returnPort}" ]]; then
    # Append data
    myenv_lib_983459816_allocated_ports+=( ${returnPort} )
    # Set back to temp
    echo "myenv_lib_983459816_allocated_ports=(${myenv_lib_983459816_allocated_ports})" > ${myenv_lib_983459816_allocated_ports_file}
    # print out
    echo ${returnPort}
  fi

  # Done
  echo "" > ${myenv_lib_983459816_allocated_ports_mylock}
  if [[ -n "${returnPort}" ]]; then
    # Return here to be sure we reseted myenv_lib_983459816_allocated_ports_mylock
    return 0
  fi
  return 1
}

# This method will prepare a format string like "-e ENVK1=ENVV1 -e ENVK2=ENVV2"
myenv_lib_983459816-docker_mount_envs(){
  local estring
  estring=""
  # Just load envs that is parsed by env.sh
  # zsh syntax
  for envKey envValue in "${(@kv)myenv_env_876892765_env_assarr}"; do
    # If not empty
    if [[ -n "${estring}" ]]; then
      estring="${estring} -e ${envKey}=${envValue}"
    else
      estring="-e ${envKey}=${envValue}"
    fi
  done
  echo "${estring}"
}

myenv_lib_983459816-docker_exec(){
    local original_cmd="${@}"
    local image=$1
    shift 1
    local err=
    local errCode=0
    if [[ "${@}" =~ "(.*)::end_docker::(.*)" ]]; then
      # Do pulling image first
      # Check for existing image
      if ! docker image history "${image}" > /dev/null 2>&1; then
        # Image does not exist, do pulling
        $(docker pull "${image}" > /dev/null 2>&1) &
        local pullPID=$!
        echo "Do pulling the docker image ${image} at PID ${pullPID}"
        wait $pullPID
      else
        # The image exists
        # Check the image tag, if it is the latest, do pulling again in background
        local imageTag=$(grep -oP '(?<=:)\w+$' <(echo "${image}"))
        if [[ -z "${imageTag}" ]] || [[ "${imageTag}" == "latest" ]]; then
          nohup docker pull "${image}" > /dev/null 2>&1 &
          echo "Checking update for the image ${image} at PID $!"
          disown # command removes the job from the shell's job control, preventing it from sending any notifications or signals to the terminal.
        fi
      fi

      local docker_args="${match[1]}"
      local docker_arg_mount_envs
      docker_arg_mount_envs="$(myenv_lib_983459816-docker_mount_envs)"
      if [[ -n "${docker_arg_mount_envs}" ]]; then
        # Put docker_arg_mount_envs after docker_args, override envs in docker_args if needed
        docker_args="${docker_args} ${docker_arg_mount_envs}"
      fi
      local query_args="${match[2]}"
      # https://unix.stackexchange.com/questions/474177/how-to-redirect-stderr-in-a-variable-but-keep-stdout-in-the-console
      # Take stderr to err variable
      local the_docker_command="docker run --rm -it ${docker_args} ${image}"
      local the_command="${the_docker_command} ${query_args}"
      # Load custom function to modify the_command for specific image
      # Format: myenv_lib_983459816-docker_exec-<image>
      # Image example: example:latest -> example, function will be: myenv_lib_983459816-docker_exec-example
      local customFunction="${0}-$(grep -oP '[^:]+' <(echo $image))"
      if typeset -f "${customFunction}" > /dev/null; then
        the_command="$(eval "${customFunction}" "${the_command}")"
      fi
      { err=$(eval "${the_command}" 2>&1 >&3 3>&-); } 3>&1
      errCode=$?
      if (( ${errCode} != 0 )); then
        # Check the exit code for sure it's from docker or query args
        echo "The command: '$(myenv_lib_983459816_set_color "${the_command}")'"
        echo "The error: '$(myenv_lib_983459816_set_color "${err}")'"
      fi
    else
      echo "The command is $(myenv_lib_983459816_set_color 'mismatched')"
      echo "The original input command: '$(myenv_lib_983459816_set_color "${original_cmd}")'"
      errCode=1
    fi
    
    return ${errCode}
}


myenv_lib_983459816-docker_exec-example(){
  local argvs="${@}"
  echo "${argvs}"
}

ansible_playbook_func(){
  # The option to let ansible ask your sudo password
  local ansible_ask_become_pass_param
  ansible_ask_become_pass_param="--ask-become-pass"
  # Check if the user can run sudo without a password prompt
  if sudo -n true 2>/dev/null; then
    # Sudo can be run without a password prompt.
    ansible_ask_become_pass_param=""
  fi
  ANSIBLE_CONFIG="${MYENV_DIR}/ansible_dir/ansible.cfg" ansible-playbook ${ansible_ask_become_pass_param} --flush-cache "$@"
  return $?
}

ansible_inventory_func(){
  ANSIBLE_CONFIG="${MYENV_DIR}/ansible_dir/ansible.cfg" ansible-inventory "$@"
  return $?
}

ansible_galaxy_func(){
  ANSIBLE_CONFIG="${MYENV_DIR}/ansible_dir/ansible.cfg" ansible-galaxy "$@"
  return $?
}

# TODO: Currently we have some softwares depend on docker engine
# Some softwares are not compatible to use in typical way when it's in a container
# Planning to install them natively on host
myenv_lib_983459816_install(){
  local input="${1}"
  local returnCode=
  returnCode=0

  case "${input}" in
    bundle)
      ANSIBLE_LOCALHOST_WARNING=False ansible_playbook_func "${MYENV_DIR}/ansible_dir/bundle.playbook.yml"
    ;;
    *)
      returnCode=1
      if [[ -z "${input}" ]]; then
        echo "Your input is $(myenv_lib_983459816_set_color "empty" '1;31')"
      else
        echo "Your input: $(myenv_lib_983459816_set_color "${input}" '1;92')"
        # Try to install the input, return to the result
        # Pass input as install_package_name ansible variable
        ANSIBLE_LOCALHOST_WARNING=False ansible_playbook_func --extra-vars "{'install_package_name':'${input}'}" "${MYENV_DIR}/ansible_dir/customize_installer.playbook.yml"
        returnCode=$?
      fi
      if (( $(echo "${returnCode} != 0" | bc -l) )); then
        echo "Currently input support: $(myenv_lib_983459816_set_color "bundle" '1;92')"
      else
        echo "The $(myenv_lib_983459816_set_color "${input}" '1;92') package has been $(myenv_lib_983459816_set_color "installed" '1;92')"
      fi
    ;;
  esac
  return ${returnCode}
}
