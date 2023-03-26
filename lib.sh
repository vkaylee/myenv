#!/bin/sh
# This function is used to check the existent command or not
has_command(){
  # Usage: has_command <command_name>
  # Check whether a command exists
  # $1 the actual command you want to check
  # Aliases included by option -v
  if command -v "$1" >/dev/null 2>&1; 
  then
    return 0 # exists
  fi
  return 1 # does not exist
}
setAlias(){
  # Input:
  # $1: The alias command that you want to register
  # $2: The command string
  # Return:
  # 0: set ok
  # 1: set failed
  local aliasCommand=$1
  local realCommand=$2
  if has_command "${aliasCommand}" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}
is_root_user() {
  # Returns 0 if root, 1 if non-root
  if [[ $EUID -eq 0 || $(id -u) -eq 0 ]]; then
    return 0 # Return 0 if root
  fi
  return 1 # Return 1 if non-root
}
check_run_as_root(){
  # Usuage: check_run_as_root <message you want to show>
  if ! is_root_user > /dev/null 2>&1; then
    if [[ "${1}x" == "x" ]]; then
      echo "$1"
    else
      echo "You must run as root!"
    fi
    exit 1
  fi
}