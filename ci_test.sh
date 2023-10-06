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
show_test(){
    echo "Test: $@"
}
# Test MYENV_DIR, default: ~/.myenv
show_test 'seeing MYENV_DIR, default: ~/.myenv'
grep -E 'MYENV_DIR=\/home\/docker\/\.myenv$' <(zsh_session_exec 'printenv')
# Test MYENV_AUTOUPDATE, it will be true by default
show_test 'seeing MYENV_AUTOUPDATE=true'
grep -E 'MYENV_AUTOUPDATE=true$' <(zsh_session_exec 'printenv')
# Test MYENV_AUTOUPDATE=false when updating .env
show_test 'seeing MYENV_AUTOUPDATE=false when updating .env'
echo "MYENV_AUTOUPDATE=false" >> "${USER_DIR}/.env"
grep -E 'MYENV_AUTOUPDATE=false$' <(zsh_session_exec 'printenv')
# Test MYENV_AUTOUPDATE=true when updating $(pwd)/.env.myenv
show_test 'seeing MYENV_AUTOUPDATE=true when updating $(pwd)/.env.myenv'
echo "MYENV_AUTOUPDATE=true" >> "$(pwd)/.env.myenv"
grep -E 'MYENV_AUTOUPDATE=true$' <(zsh_session_exec 'printenv')

# Set MYENV_AUTOUPDATE=false to avoid waiting for confirmation update when creating a new shell session
echo "MYENV_AUTOUPDATE=false" >> "$(pwd)/.env.myenv"

# Test MYENV_APPCONFIG_DIR
show_test 'seeing MYENV_APPCONFIG_DIR env'
grep -E 'MYENV_APPCONFIG_DIR=\/home\/docker\/\.myenv\/appconfig$' <(zsh_session_exec 'printenv')
# Test MYENV_PACKAGE_MANAGER
show_test 'seeing MYENV_PACKAGE_MANAGER env'
grep -E 'MYENV_PACKAGE_MANAGER=\w+$' <(zsh_session_exec 'printenv')
# Test MYENV_VERSION
show_test 'seeing MYENV_VERSION env'
grep -E 'MYENV_VERSION=\w+$' <(zsh_session_exec 'printenv')

# Test command: myenv
show_test 'command, myenv'
grep -E 'Usage: myenv' <(zsh_session_exec 'myenv')
grep -E 'Current version:' <(zsh_session_exec 'myenv')

# Test command: myenv envs
show_test 'command, myenv envs'
echo "TEST_ENV=test_env" >> "${USER_DIR}/.env"
grep -E 'TEST_ENV=test_env' <(zsh_session_exec 'myenv')
grep -E '\/\.env' <(zsh_session_exec 'myenv')

echo "TEST_ENV=test_env_myenv" >> "${USER_DIR}/.env.myenv"
grep -E 'TEST_ENV=test_env_myenv' <(zsh_session_exec 'myenv')
grep -E '\/\.env.myenv' <(zsh_session_exec 'myenv')
