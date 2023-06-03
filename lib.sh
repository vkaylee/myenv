#!/usr/bin/env zsh
# Define an array to store all guideline about all aliases
alias_array_983459816542476252=()

typing_style_print_185481790819876189579791751(){
  local my_print_text="${1-}"
  local typing_speed="${2-0.05}"
  for ((i=0; i<=${#my_print_text}; i++)); do
      printf '%s' "${my_print_text:$i:1}"
      sleep "${typing_speed}"
  done
}
array_printer_877612354827582(){
  # 1: "${myArray[@]}"
  local myArray=("$@")
  for item in "${myArray[@]}";do
    typing_style_print_185481790819876189579791751 "- ${item}" 0.0005
    printf '\n'
    sleep 0.05
  done
}

set_alias_array_86572659873897235681257813245172356417235(){
  local value="${1-}"
  if [ -n "${value}" ]; then
    alias_array_983459816542476252+=("${value}")
  fi
}
print_alias_array_865726598738972356812578132451723564172(){
  array_printer_877612354827582 "${alias_array_983459816542476252[@]}"
}
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
  local directedShow="${4:-false}"

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
  if $directedShow ; then
    typing_style_print_185481790819876189579791751 "${retStr}" 0.005
    printf "\n"
  else
    set_alias_array_86572659873897235681257813245172356417235 "${retStr}"
  fi
}