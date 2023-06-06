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

## Manual install, go to -- [Installers](INSTALLERS.md)