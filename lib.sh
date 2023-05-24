#!/usr/bin/env zsh
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
set_command_alias(){
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
  
  if ! has_command "${aliasCommand}" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}

set_command_aliases(){
  local aliases=$1
  local realCommand=$2
  local description=$3
  aliasCommands=(${(@s:,:)aliases})

  local okAliasesStr=()
  local noOkAliasesStr=()
  local delimiter=','

  for command in ${aliasCommands[@]}; do
    if set_command_alias "${command}" "${realCommand}" > /dev/null 2>&1; then
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
  echo "${retStr}"
}