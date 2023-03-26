#!/bin/bash
# Exit on any error
set -e
# Take working directory
this_file_path="$(readlink -f "$0")"
work_dir=$(dirname "${this_file_path}")
# Install zsh
if ! command -v "zsh" >/dev/null 2>&1; 
then
  # Install zsh by apt-get command line
  if command -v "apt-get" >/dev/null 2>&1; 
  then
    sudo apt-get update && sudo apt-get install -y zsh
  else
    # Implement more for yum, dnf, brew
    echo "your current system is not supported this time"
    exit 1
  fi
fi
# make zsh as default shell for the user
if [ "${SHELL}" != "$(which zsh)" ]; then
  echo ${USER} | sudo chsh -s $(which zsh)
fi
# Install oh-my-zsh
yes Y | sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# Install plugin zsh-autosuggestions
USER_DIR="$(echo ~)"
zsh_autosuggestions_dir="${USER_DIR}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ -d "${zsh_autosuggestions_dir}" ]; then
  rm -rf "${zsh_autosuggestions_dir}"
fi
# Clone zsh-autosuggestions git repo
git clone https://github.com/zsh-users/zsh-autosuggestions "${zsh_autosuggestions_dir}"
# Check zsh-autosuggestions configuration in zshrc
ZSHRC_PATH="${USER_DIR}/.zshrc"
if ! grep "zsh-autosuggestions" "${ZSHRC_PATH}" >/dev/null 2>&1; then
  # Add to plugins before loading oh-my-zsh
  line_num=$(egrep -nE '^source .+oh-my-zsh\.sh' "${ZSHRC_PATH}" | sed 's/[^0-9]//g')
  sed -i "${line_num} i plugins+=(zsh-autosuggestions)" "${ZSHRC_PATH}"
  unset ${line_num}
fi

# Set ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=22'
sed -i 's/fg=[0-9]*/fg=22/g' "${zsh_autosuggestions_dir}/src/config.zsh"

if ! grep "${work_dir}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1; then
  # Add to plugins before loading oh-my-zsh
  line_num=$(egrep -nE '^source .+oh-my-zsh\.sh' "${ZSHRC_PATH}" | sed 's/[^0-9]//g')
  sed -i "${line_num} i plugins+=(zsh-autosuggestions)" "${ZSHRC_PATH}"
  unset ${line_num}
fi

# Add myenv to zsh
grep "${work_dir}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1 || tee -a "${ZSHRC_PATH}" >/dev/null 2>&1 <<EOF
# Load customize configuration myenv
source "${work_dir}/import.sh"
EOF