#!/usr/bin/env bash
input_user="$1"
file_dir_url="$2"
USER_DIR="/home/docker/.myenv"
# Test setup
# Run the setup script under a user
sudo su -c "export fileDirUrl=\"${file_dir_url}\"; bash <(curl -sSL \"\${fileDirUrl}/setup.sh?\$(date +%s)\") test" "${input_user}"
# Test MYENV_DIR, default: ~/.myenv
grep -E 'MYENV_DIR=\/home\/docker\/\.myenv$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE, it will be true by default
grep -E 'MYENV_AUTOUPDATE=true$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=false when updating .env
echo "MYENV_AUTOUPDATE=false" >> "${USER_DIR}/.env"
grep -E 'MYENV_AUTOUPDATE=false$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=true when updating $(pwd)/.env.myenv
echo "MYENV_AUTOUPDATE=true" >> "$(pwd)/.env.myenv"
grep -E 'MYENV_AUTOUPDATE=true$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_APPCONFIG_DIR
grep -E 'MYENV_APPCONFIG_DIR=\/home\/docker\/\.myenv\/appconfig$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_PACKAGE_MANAGER
grep -E 'MYENV_PACKAGE_MANAGER=\w+$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_VERSION
grep -E 'MYENV_VERSION=\w+$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')