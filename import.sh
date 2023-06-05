#!/usr/bin/env zsh
# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
MYENV_DIR=$(dirname "${this_file_path}")
export MYENV_DIR
MYENV_AUTOUPDATE=true
export MYENV_AUTOUPDATE
# Load lib
source "${MYENV_DIR}/lib.sh"
# Load environments
source "${MYENV_DIR}/env.sh"

# Check update
# This feature is enable by default, disable it by adding MYENV_AUTOUPDATE=false to your env file
if $MYENV_AUTOUPDATE; then
  myenv_lib_983459816_update
fi

# Load detect package_manager script
source "${MYENV_DIR}/detection_scripts/package_manager.sh"

# Load some init for package managers
source "${MYENV_DIR}/package_managers.sh"

# aliases
source "${MYENV_DIR}/aliases.sh"
# MyContainer
source "${MYENV_DIR}/mycontainer.sh"

# Load all custom scripts, the list will be ordered by name
mkdir -p "${MYENV_DIR}/personal_scripts"
find "${MYENV_DIR}/personal_scripts/" -maxdepth 1 -type f -name "*.sh" -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F '\0' '{print $3}' | while read personal_script_path
do
    source "${personal_script_path}"
done

display_usage_2786926592856128937561728654782561829560735() {
  typeset -A argvs=()
  argvs[aliases]='Show all aliases'
  argvs[envs]='Show all envs are set by myenv'
  argvs[update]='Update myenv'
  argvs[reload]='Reload myenv'

	myenv_lib_983459816_typing_style_print "Usage: myenv [arguments]"
	printf "\n"
	myenv_lib_983459816_typing_style_print "arguments:"
	printf "\n"
	for key in ${(k)argvs}; do
	  printf "\t"
    myenv_lib_983459816_typing_style_print "- $key: ${argvs[$key]}"
    printf "\n"
    sleep 0.05
  done
  # print the current version of myenv
  myenv_lib_983459816_typing_style_print "Current version: ${MYENV_VERSION}"; printf "\n"
}

myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354(){
  local firstInput="${1-}"
  case ${firstInput} in
  aliases)
    myenv_lib_983459816_print_alias_array
    ;;
  envs)
    myenv_env_876892765_show_envs
    ;;
  update)
    myenv_lib_983459816_update true
    ;;
  reload)
    exec "${SHELL}"
    ;;
  *)
    display_usage_2786926592856128937561728654782561829560735
    ;;
  esac
}
myenv_lib_983459816_set_command_aliases 'myenv' 'myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354' 'MYENV helper, try with command' true


# Set MYENV_VERSION after loading
MYENV_VERSION=$(git --git-dir="${MYENV_DIR}/.git" rev-parse --short HEAD)
export MYENV_VERSION