#!/usr/bin/env bash
input_user="$1"
file_dir_url="$2"
USER_DIR="/home/docker/.myenv"
# Test setup
# Run the setup script under a user
sudo su -c "export fileDirUrl=\"${file_dir_url}\"; bash <(curl -sSL \"\${fileDirUrl}/setup.sh?\$(date +%s)\") test" "${input_user}"
# Test MYENV_DIR, default: ~/.myenv
echo "Test env MYENV_DIR"
grep -E 'MYENV_DIR=\/home\/docker\/\.myenv$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE, it will be true by default
echo "Test env MYENV_AUTOUPDATE default value"
grep -E 'MYENV_AUTOUPDATE=true$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=false when updating .env
echo "Test env MYENV_AUTOUPDATE when updating it in .env file"
echo "MYENV_AUTOUPDATE=false" >> "${USER_DIR}/.env"
grep -E 'MYENV_AUTOUPDATE=false$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_AUTOUPDATE=true when updating $(pwd)/.env.myenv
echo "Test env MYENV_AUTOUPDATE when updating it in .env.myenv file"
echo "MYENV_AUTOUPDATE=true" >> "$(pwd)/.env.myenv"
grep -E 'MYENV_AUTOUPDATE=true$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_APPCONFIG_DIR
echo "Test env MYENV_APPCONFIG_DIR"
grep -E 'MYENV_APPCONFIG_DIR=\/home\/docker\/\.myenv\/appconfig$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_PACKAGE_MANAGER
echo "Test env MYENV_PACKAGE_MANAGER"
grep -E 'MYENV_PACKAGE_MANAGER=\w+$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')
# Test MYENV_VERSION
echo "Test env MYENV_VERSION"
grep -E 'MYENV_VERSION=\w+$' <("$(which zsh)" -c 'source $HOME/.zshrc; printenv')

# Test command: myenv
echo "Test command: myenv"
grep -E 'Usage: myenv' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')
grep -E 'Current version:' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')

# Test command: myenv envs
echo "Test command: myenv envs"
echo "Test for sure we have env in the file .env"
echo "TEST_ENV=test_env" >> "${USER_DIR}/.env"
grep -E 'TEST_ENV=test_env' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')
echo "Test for sure the user knows the .env file is loaded"
grep -E '\/\.env' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')

echo "Test for sure we have env in the file .env.myenv"
echo "TEST_ENV=test_env_myenv" >> "${USER_DIR}/.env.myenv"
grep -E 'TEST_ENV=test_env_myenv' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')
echo "Test for sure the user knows the .env.myenv file is loaded"
grep -E '\/\.env.myenv' <("$(which zsh)" -c 'source $HOME/.zshrc; myenv')

# Test myenv.sh in working directory
echo "Test the file myenv.sh must be loaded in the current working directory"
echo 'export PATH=$PATH:/mytest' > "${USER_DIR}/myenv.sh"
grep -E ':\/mytest$' <("$(which zsh)" -c 'source $HOME/.zshrc; echo $PATH')

# Test myenv.sh by a custom name in working directory (set in .env)
echo "Test the file myenv.sh in a custom name by setting MYENV_CUSTOMIZATION_FILENAME in .env must be loaded in the current working directory"
echo "MYENV_CUSTOMIZATION_FILENAME=hello.sh" >> "${USER_DIR}/.env"
echo 'export PATH=$PATH:/mytest_hello.sh' > "${USER_DIR}/hello.sh"
grep -E ':\/mytest_hello\.sh$' <("$(which zsh)" -c 'source $HOME/.zshrc; echo $PATH')

# Test myenv.sh by a custom name in working directory (set in .env.myenv)
echo "Test the file myenv.sh in a custom name by setting MYENV_CUSTOMIZATION_FILENAME in .env.myenv must be loaded in the current working directory"
echo "MYENV_CUSTOMIZATION_FILENAME=hello_working.sh" >> "${USER_DIR}/.env.myenv"
echo 'export PATH=$PATH:/mytest_hello_working.sh' > "${USER_DIR}/hello_working.sh"
grep -E ':\/mytest_hello_working\.sh$' <("$(which zsh)" -c 'source $HOME/.zshrc; echo $PATH')
