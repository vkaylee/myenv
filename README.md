# MYENV development environment
[![Integration Testing](https://github.com/vleedev/myenv/actions/workflows/integration_test.yml/badge.svg?branch=main)](https://github.com/vleedev/myenv/actions/workflows/integration_test.yml)
## Features
- Set all environment variables to the shell session
    - `.env` in this directory (General variables)
    - `.env.myenv` in your working directory (Specific variables). (Tip: you can create a symlink to your env file if you don't want to create a new file to store your env variable)
- `myenv.sh` in your working directory will be loaded when your session start
    - The file does not exist by default.
    - Automatically when you start new shell session at a working directory.
    - Manually when you run `myenv reload` command.
    - Customize filename instead of `myenv.sh`, update your ENV `MYENV_CUSTOMIZATION_FILENAME`
    - It has some advantages:
        - Custom `PATH` env to your shell session.
        - Other customizations that your want to load at a working directory.
- Manually install a pre-defined set of software by `myenv install <input>`
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

## Manual install, go to -- [Installers](INSTALLERS.md)

## Development
### Run local test
```shell
./test.local.sh
```