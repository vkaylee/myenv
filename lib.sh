#!/usr/bin/env bash
# This function is used to check the existent command or not
# It depends on which command
hasCommand(){
  # Input:
  # $1: command string
  # Return:
  # 0: Has the command
  # 1: Do not have the command
  local command=$1
  which "${command}" > /dev/null 2>&1
  local statusCode=$?
  if [ ${statusCode} -eq 1 ]; then
    return 1 # Does not have the command
  fi
  return 0 # Has the command
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
  if ! hasCommand "${aliasCommand}" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}
isRootUser(){
  # Input: no inputs
  # Return:
  # 0: This is root
  # 1: This is not root
  local isRoot=1 # By default: this is not root account
  # Check running as root
  if test ${isRoot} -eq 1 && [ "${EUID}" -eq 0 ]; then
    isRoot=0
  fi

  if test ${isRoot} -eq 1 && [ '0' == "$(id -u)" ]; then
    isRoot=0
  fi

  return ${isRoot}
}
rootNeeded(){
  if ! isRootUser > /dev/null 2>&1; then
    echo "You must run as root!"
    exit 1
  fi
}