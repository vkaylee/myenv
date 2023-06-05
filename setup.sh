#!/usr/bin/env bash
# Exit on any error
set -e
# Take working directory
this_file_path="$(readlink -f "$0")"
work_dir=$(dirname "${this_file_path}")
github_url="https://raw.githubusercontent.com/vleedev/myenv/main"

# The method to download and echo to current screen
myenv_setup_663358564_load_script_url(){
  echo "Please install curl or wget first"
  exit 1
}
# Detect download tool
for downloadTool in "curl" "wget"; do
  if command -v "${downloadTool}" >/dev/null 2>&1; then
    # Override the myenv_setup_663358564_download method
    myenv_setup_663358564_load_script_url(){
      local url="${1-}"
      local options="-sSL" # Default option for curl
      if [[ "${downloadTool}" == "wget" ]]; then
        options="-O-"
      fi
      eval "${downloadTool} ${options} ${url}"
    }
    break
  fi
done

# Detect package manager first
source <(myenv_setup_663358564_download "${github_url}/detection_scripts/package_manager.sh")
if [[ -z "${MYENV_PACKAGE_MANAGER}" ]]; then
  echo "Package manager is not found"
  exit 1
fi

# Load utils
source <(myenv_setup_663358564_download "${github_url}/package_managers/${MYENV_PACKAGE_MANAGER}.sh")

USER_DIR="$(echo ~)"
# Install zsh
if ! command -v "zsh" >/dev/null 2>&1; 
then
  # Install zsh by apt-get command line
  if command -v "apt-get" >/dev/null 2>&1; 
  then
    sudo apt-get update && sudo apt-get install -y zsh
  # Install zsh by apt-get command line
  elif command -v "dnf" >/dev/null 2>&1;
  then
    sudo dnf update && sudo dnf install -y zsh
  else
    # Implement more for yum, dnf, brew
    echo "your current system is not supported this time"
    exit 1
  fi
fi
# make zsh as default shell for the user
if [ "${SHELL}" != "$(which zsh)" ]; then
  zsh_path=$(which zsh)
  if command -v "chsh" >/dev/null 2>&1; 
  then
    sudo chsh -s "${zsh_path}" ${USER}
  elif command -v "usermod" >/dev/null 2>&1;
  then
    sudo usermod -s "${zsh_path}" ${USER}
  else
    echo "your current system is not supported to set zsh as default shell"
    exit 2
  fi
fi
# Install oh-my-zsh
if [ -d "${USER_DIR}/.oh-my-zsh" ]; then
  rm -rf "${USER_DIR}/.oh-my-zsh"
fi
yes Y | bash -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# Install plugin zsh-autosuggestions
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
fi

# Set ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=22'
sed -i 's/fg=[0-9]*/fg=22/g' "${zsh_autosuggestions_dir}/src/config.zsh"

if ! grep "${work_dir}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1; then
  # Add to plugins before loading oh-my-zsh
  line_num=$(egrep -nE '^source .+oh-my-zsh\.sh' "${ZSHRC_PATH}" | sed 's/[^0-9]//g')
  sed -i "${line_num} i plugins+=(zsh-autosuggestions)" "${ZSHRC_PATH}"
fi

# Add myenv to zsh
grep "${work_dir}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1 || tee -a "${ZSHRC_PATH}" >/dev/null 2>&1 <<EOF
# Load customize configuration myenv
source "${work_dir}/import.sh"
EOF
