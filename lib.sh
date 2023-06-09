#!/usr/bin/env zsh
# Namespace: start with myenv_lib_983459816_ and end with 
# Define an array to store all guideline about all aliases
myenv_lib_983459816_alias_array=()

myenv_lib_983459816_typing_style_print(){
  local my_print_text="${1-}"
  local typing_speed="${2-0.005}"
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
  # Aliases included by option -v
  if command -v "$1" >/dev/null 2>&1; 
  then
    return 0 # exists
  fi
  return 1 # does not exist
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

  for command in ${aliasCommands[@]}; do
    if myenv_lib_983459816_set_alias_command "${command}" "${realCommand}" > /dev/null 2>&1; then
      if [[ -n "${okAliasesStr}" ]]; then
        okAliasesStr="${okAliasesStr}${delimiter}${command}"
      else
        okAliasesStr="${command}"
      fi
    else
      if [[ -n "${noOkAliasesStr}" ]]; then
        noOkAliasesStr="${noOkAliasesStr}${delimiter}${command}"
      else
        noOkAliasesStr="${command}"
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

myenv_lib_983459816-docker_exec(){
    local err=
    local errCode=0
    # https://unix.stackexchange.com/questions/474177/how-to-redirect-stderr-in-a-variable-but-keep-stdout-in-the-console
    # Take stderr to err variable
    { err=$(docker "${@}" 2>&1 >&3 3>&-); } 3>&1
    errCode=$?
    if (( ${errCode} != 0 )); then
      echo "The command: docker ${@}"
      echo "The error: ${err}"
    fi
    return ${errCode}
}
