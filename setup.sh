#!/usr/bin/env bash
# Exit on any error
set -e
if [[ -n "${MYENV_DEBUG}" ]]; then
  set -x
fi
# Use this session to url when using curl wget to avoid caching
MYENV_SESSION_TIME="$(date +%s)"
# ENV: fileDirUrl
if [ -z "${fileDirUrl}" ]; then
    fileDirUrl="https://raw.githubusercontent.com/vleedev/myenv/main"
fi
# ENV: gitRepoUrl
if [ -z "${gitRepoUrl}" ]; then
  gitRepoUrl="https://github.com/vleedev/myenv.git"
fi

# The method to download and echo to current screen
myenv_setup_663358564_load_script_url(){
  echo "Please install curl or wget first"
  return 1
}
# Detect download tool
for downloadTool in "curl" "wget"; do
  if command -v "${downloadTool}" >/dev/null 2>&1; then
    # Override the myenv_setup_663358564_load_script_url method
    myenv_setup_663358564_load_script_url(){
      local url="${1-}"
      # The option --fail or --no-clobber will treat error if a request is a http error code
      local options="--fail -sSL" # Default option for curl
      if [[ "${downloadTool}" == "wget" ]]; then
        options="--no-clobber -O-"
      fi
      eval "${downloadTool} ${options} ${url}"
    }
    break
  fi
done

# Detect package manager first
# Source the stdout, ignore stderr
# shellcheck source=detection_scripts/package_manager.sh
source <(myenv_setup_663358564_load_script_url "${fileDirUrl}/detection_scripts/package_manager.sh?${MYENV_SESSION_TIME}" 2>/dev/null)
if [[ -z "${MYENV_PACKAGE_MANAGER}" ]]; then
  echo "Package manager is not found"
  exit 1
fi

# Load utils
# Source the stdout, ignore stderr
# shellcheck source=package_managers/[package_manager].sh
source <(myenv_setup_663358564_load_script_url "${fileDirUrl}/package_managers/${MYENV_PACKAGE_MANAGER}.sh?${MYENV_SESSION_TIME}" 2>/dev/null)

# Install git
myenv_package_managers_632264331_install git

# Install zsh
myenv_package_managers_632264331_install zsh

# Install python3
myenv_package_managers_632264331_install python3

# Install python3-pip
myenv_package_managers_632264331_install python3-pip

# Install pipx

if [ "$(command -v pip)" ]; then
  if ! pip install --user pipx; then
    if ! python3 -m pip install --user pipx; then
      myenv_package_managers_632264331_install pipx
    fi
  fi
fi

# Install ansible
if [ "$(command -v pipx)" ]; then
  install_ansible(){
    local install_loop_count
    install_loop_count=1
    while true; do
      if pipx install --include-deps ansible; then
        break
      fi
      if [[ ${install_loop_count} -gt 2 ]]; then
        break
      fi
      # Increase install_loop_count
      ((install_loop_count++))
    done
  }
  install_ansible
fi

USER_DIR="$(echo ~)"

# make zsh as default shell for the user
if [ "${SHELL}" != "$(which zsh)" ]; then
  zsh_path=$(which zsh)
  # Check /etc/shells list
  if ! grep "${zsh_path}" < "/etc/shells"; then
    echo "${zsh_path}" | sudo tee -a "/etc/shells" > /dev/null
  fi
  # Set default
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
  # Check user shell
  if ! grep "^${USER}:" < "/etc/passwd" | grep "$(which zsh)"; then
    echo "your shell is not changed"
    exit 2
  fi
fi
# Install oh-my-zsh
if [ -d "${USER_DIR}/.oh-my-zsh" ]; then
  rm -rf "${USER_DIR}/.oh-my-zsh"
fi
yes Y | bash -c "$(myenv_setup_663358564_load_script_url https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

# Clone myenv
# Default dir will be ${USER_DIR}/.myenv
# If you want to change it, set MYENV_DIR before running this script
if [[ -z "${MYENV_DIR}" ]]; then
  MYENV_DIR="${USER_DIR}/.myenv"
fi

if ! git clone "${gitRepoUrl}" "${MYENV_DIR}"; then
  echo "Can not clone ${gitRepoUrl} to ${MYENV_DIR}"
  exit 1
fi

if ! grep "${MYENV_DIR}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1; then
  # Add to plugins before loading oh-my-zsh
  line_num=$(egrep -nE '^source .+oh-my-zsh\.sh' "${ZSHRC_PATH}" | sed 's/[^0-9]//g')
  sed -i "${line_num} i plugins+=(zsh-autosuggestions)" "${ZSHRC_PATH}"
fi

# Add myenv to zsh
grep "${MYENV_DIR}/import.sh" "${ZSHRC_PATH}" >/dev/null 2>&1 || tee -a "${ZSHRC_PATH}" >/dev/null 2>&1 <<EOF
# Load customize configuration myenv
source "${MYENV_DIR}/import.sh"
EOF

# Restart shell session when the first input is not "test"
if [[ "${1}" != "test" ]]; then
  # Replace the current shell session by creating the new shell session
  exec "$(which zsh)"
else
  # Simulate the way when zsh creates a new shell session
  # It should be gone with option: -c with simple action
  grep -qE 'Current process ID:.+[0-9]+' <(zsh -i -c 'echo ok')
fi
