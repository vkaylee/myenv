#!/usr/bin/env bash

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  if [[ -z ${packageName} ]]; then
    return
  fi
  if [[ ${packageName} == "git" ]]; then
    # For Ubuntu, this PPA provides the latest stable upstream Git version
    if command -v "add-apt-repository" >/dev/null 2>&1; then
      sudo add-apt-repository ppa:git-core/ppa
    fi
  fi
  sudo apt update
  sudo apt install -y "${packageName}"
}