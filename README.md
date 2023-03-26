## Quick start:
`Bash` shell must be `pre-installed` to run `setup.sh`
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
Put all `ENV_KEY=ENV_VALUE` to the `.env` file