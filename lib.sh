#!/usr/bin/env zsh
# Namespace: start with lib_ and end with _983459816542476252
# Define an array to store all guideline about all aliases
alias_array_983459816542476252=()

lib_typing_style_print_983459816542476252(){
  local my_print_text="${1-}"
  local typing_speed="${2-0.005}"
  for ((i=0; i<=${#my_print_text}; i++)); do
      printf '%s' "${my_print_text:$i:1}"
      sleep "${typing_speed}"
  done
}
lib_array_printer_983459816542476252(){
  # 1: "${myArray[@]}"
  local myArray=("$@")
  for item in "${myArray[@]}";do
    lib_typing_style_print_983459816542476252 "- ${item}" 0.0005
    printf '\n'
    sleep 0.05
  done
}

lib_set_alias_array_983459816542476252(){
  local value="${1-}"
  if [ -n "${value}" ]; then
    alias_array_983459816542476252+=("${value}")
  fi
}
lib_print_alias_array_983459816542476252(){
  lib_array_printer_983459816542476252 "${alias_array_983459816542476252[@]}"
}
# This function is used to check the existent command or not
lib_has_command_983459816542476252(){
  # Usage: lib_has_command_983459816542476252 <command_name>
  # Check whether a command exists
  # $1 the actual command you want to check
  # Aliases included by option -v
  if command -v "$1" >/dev/null 2>&1; 
  then
    return 0 # exists
  fi
  return 1 # does not exist
}
lib_set_alias_command_983459816542476252(){
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
  
  if ! lib_has_command_983459816542476252 "${aliasCommand}" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${aliasCommand}"="${realCommand}"
    echo "You can use command '${aliasCommand}' as '${realCommand}'"
    return 0
  fi
  echo "You can not use command '${aliasCommand}' as '${realCommand}' because '${aliasCommand}' was a command already! Please check with command 'which ${aliasCommand}' for more info"
  return 1
}

lib_set_command_aliases_983459816542476252(){
  local aliases=$1
  local realCommand=$2
  local description=$3
  local directedShow="${4:-false}"

  aliasCommands=(${(@s:,:)aliases})

  local okAliasesStr=()
  local noOkAliasesStr=()
  local delimiter=','

  for command in ${aliasCommands[@]}; do
    if lib_set_alias_command_983459816542476252 "${command}" "${realCommand}" > /dev/null 2>&1; then
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
    lib_typing_style_print_983459816542476252 "${retStr}" 0.005
    printf "\n"
  else
    lib_set_alias_array_983459816542476252 "${retStr}"
  fi
}

lib_confirm_983459816542476252()
{
  read -r -s input
  echo "${input}"
  case "${input}" in
    [Yy]* ) return 0;;
    * ) return 1;;
  esac
}