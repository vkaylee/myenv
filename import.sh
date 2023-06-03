#!/usr/bin/env zsh
# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
MYENV_DIR=$(dirname "${this_file_path}")
export MYENV_DIR
# Load lib
source "${MYENV_DIR}/lib.sh"
# Load environments
source "${MYENV_DIR}/env.sh"
# Load detect.sh script
source "${MYENV_DIR}/detect.sh"
# aliases
source "${MYENV_DIR}/aliases.sh"
# MyContainer
source "${MYENV_DIR}/mycontainer.sh"

# Load all custom scripts, the list will be ordered by name
find "${MYENV_DIR}/personal_scripts/" -maxdepth 1 -type f -name "*.sh" -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F '\0' '{print $3}' | while read personal_script_path
do
    source "${personal_script_path}"
done

display_usage_2786926592856128937561728654782561829560735() {
  declare -A argvs=()
  argvs[aliases]='Show all aliases'

	typing_style_print_185481790819876189579791751 "Usage: myenv [arguments]"
	printf "\n"
	typing_style_print_185481790819876189579791751 "arguments:"
	printf "\n"
	for key in ${(k)argvs}; do
	  printf "\t"
    typing_style_print_185481790819876189579791751 "- $key: ${argvs[$key]}"
    printf "\n"
    sleep 0.05
  done
}

myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354(){
  local firstInput="${1-}"
  case ${firstInput} in
  aliases)
    print_alias_array_865726598738972356812578132451723564172
    ;;
  *)
    display_usage_2786926592856128937561728654782561829560735
    ;;
  esac
}
set_command_aliases 'myenv' 'myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354' 'MYENV helper' true
