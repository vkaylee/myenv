#!/usr/bin/env bash
input_user="$1"
file_dir_url="$2"
git_repo_url="$3"
USER_DIR="/home/docker/.myenv"
# Test setup
# Run the setup script under a user
sudo su -c "export fileDirUrl=\"${file_dir_url}\"; export gitRepoUrl=\"${git_repo_url}\"; bash <(curl -sSL \"\${fileDirUrl}/setup.sh?\$(date +%s)\") test" "${input_user}"
# To create isolated zsh session: use option '-i', every shell setting will be loaded automatically as usual
# https://github.com/syl20bnr/spacemacs/issues/13401
zsh_session_exec(){
    zsh -i -c "$@"
}
# Test MYENV_DIR, default: ~/.myenv
grep -E 'MYENV_DIR=\/home\/docker\/\.myenv$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE, it will be true by default
grep -E 'MYENV_AUTOUPDATE=true$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=false when updating .env
echo "MYENV_AUTOUPDATE=false" >> "${USER_DIR}/.env"
grep -E 'MYENV_AUTOUPDATE=false$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=true when updating $(pwd)/.env.myenv
echo "MYENV_AUTOUPDATE=true" >> "$(pwd)/.env.myenv"
grep -E 'MYENV_AUTOUPDATE=true$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_APPCONFIG_DIR
grep -E 'MYENV_APPCONFIG_DIR=\/home\/docker\/\.myenv\/appconfig$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_PACKAGE_MANAGER
grep -E 'MYENV_PACKAGE_MANAGER=\w+$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')
# Test MYENV_VERSION
grep -E 'MYENV_VERSION=\w+$' <(zsh_session_exec 'source $HOME/.zshrc; printenv')

# Test command: myenv
grep -E 'Usage: myenv' <(zsh_session_exec 'source $HOME/.zshrc; myenv')
grep -E 'Current version:' <(zsh_session_exec 'source $HOME/.zshrc; myenv')

# Test command: myenv envs
echo "TEST_ENV=test_env" >> "${USER_DIR}/.env"
grep -E 'TEST_ENV=test_env' <(zsh_session_exec 'source $HOME/.zshrc; myenv')
grep -E '\/\.env' <(zsh_session_exec 'source $HOME/.zshrc; myenv')

echo "TEST_ENV=test_env_myenv" >> "${USER_DIR}/.env.myenv"
grep -E 'TEST_ENV=test_env_myenv' <(zsh_session_exec 'source $HOME/.zshrc; myenv')
grep -E '\/\.env.myenv' <(zsh_session_exec 'source $HOME/.zshrc; myenv')
