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