# MYENV development environment
## Features
- Set all environment variables to the shell session
    - `.env` in this directory (General variables)
    - `.env.myenv` in your working directory (Specific variables). (Tip: you can create a symlink to your env file if you don't want to create a new file to store your env variable)
- Set `KUBECONFIG` env
- Create some out of the box aliases
    - Docker compose: `docker-compose`, `dkc`, `docker compose`
    - Amazon Web Service: `awscli`, `aws`
    - Infrastructure as code (IAC) tool: `terraform`, `tf`
    - Google cloud command line tool: `gcloud`, `gcli`
    - Google cloud shell: `gshell`
    - Kubernetes command line interface: `kubectl`, `kctl`
- Provision environment for testing by using command `mycontainer`
## Quick start:
`Bash` shell, `curl` or `wget` tool must be `pre-installed` to run `setup.sh`
```bash
bash <(curl -sSL "https://raw.githubusercontent.com/vleedev/myenv/main/setup.sh?$(date +%s)")
```
or
```bash
bash <(wget -O- "https://raw.githubusercontent.com/vleedev/myenv/main/setup.sh?$(date +%s)")
```
or
```bash
git clone https://github.com/vleedev/myenv.git && \
./myenv/setup.sh
```
## Install zsh

- Debian (apt): ```apt update && apt install zsh```

## Set zsh as default shell

Set for the current user
    
    chsh -s $(which zsh)

Use `sudo` if you want to set default for all users (include `root` user)

Logout and login again or reboot to take the effect.
    

## Install oh-my-zsh

Visit: https://ohmyz.sh/

## Install plugin zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    
### Config:

#### .zshrc

    plugins=(zsh-autosuggestions)

#### ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/src/config.zsh

    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=22'

## Install this repo

Run the command

    git clone https://github.com/vleedev/myenv.git "${HOME}/Documents"

### Load

Put to the `.zshrc` file

    # Load customize configuration myenv
    source "${HOME}/Documents/myenv/import.sh"

### Load ENV

if you want to set your ENV to every session when you create a new session
Put all `ENV_KEY=ENV_VALUE` to the `.env` file. Create a new one if it does not exist
