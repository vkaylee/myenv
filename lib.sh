#!/usr/bin/env bash
# This function is used to check the existent command or not
# It depends on which command
hasCommand(){
  local command=$1
  which "${command}" > /dev/null 2>&1
  return $?
}
setAlias(){
  local aliasCommand=$1
  local realCommand=$2
  hasCommand "${aliasCommand}" > /dev/null 2>&1
  local exitCode=$?
  if [ ${exitCode} -eq 1 ]; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}