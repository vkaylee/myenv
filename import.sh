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
if $MYENV_AUTOUPDATE && git --git-dir="${MYENV_DIR}/.git" fetch origin > /dev/null 2>&1; then
  remoteLastCommit="$(git --git-dir="${MYENV_DIR}/.git" log origin/main | head -1 | awk '{print $2}')"
  localLastCommit="$(git --git-dir="${MYENV_DIR}/.git" log | head -1 | awk '{print $2}')"
  if [ "${remoteLastCommit}" != "${localLastCommit}" ]; then
    lib_typing_style_print_983459816542476252 "MYENV is having an update, do you want to update (y/n)? "
    if lib_confirm_983459816542476252; then
      git --git-dir="${MYENV_DIR}/.git" remote set-url origin https://github.com/vleedev/myenv.git
      git --git-dir="${MYENV_DIR}/.git" pull origin main
      git --git-dir="${MYENV_DIR}/.git" checkout main
      exec "${SHELL}"
    else
      lib_typing_style_print_983459816542476252 "Disable auto update by adding MYENV_AUTOUPDATE=false to your env file"
      printf "\n"
    fi
  fi
fi

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
  typeset -A argvs=()
  argvs[aliases]='Show all aliases'
  argvs[envs]='Show all envs are set by myenv'

	lib_typing_style_print_983459816542476252 "Usage: myenv [arguments]"
	printf "\n"
	lib_typing_style_print_983459816542476252 "arguments:"
	printf "\n"
	for key in ${(k)argvs}; do
	  printf "\t"
    lib_typing_style_print_983459816542476252 "- $key: ${argvs[$key]}"
    printf "\n"
    sleep 0.05
  done
}

myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354(){
  local firstInput="${1-}"
  case ${firstInput} in
  aliases)
    lib_print_alias_array_983459816542476252
    ;;
  envs)
    myenv_show_envs_876892765834465872652357846459283659
    ;;
  *)
    display_usage_2786926592856128937561728654782561829560735
    ;;
  esac
}
lib_set_command_aliases_983459816542476252 'myenv' 'myenv_alias_helper_8917263589165176548325478456735683745682746518273568127547623547265472549126354' 'MYENV helper, try with command' true
