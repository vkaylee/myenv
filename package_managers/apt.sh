#!/usr/bin/env bash

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  local command="${2-packageName}"
  if [ -z "${packageName}" ] || [ -z "${command}" ]; then
    return
  fi
  if command -v "${command}" >/dev/null 2>&1; then
    return
  fi
  if [[ ${packageName} == "git" ]]; then
    # For Ubuntu, this PPA provides the latest stable upstream Git version
    if command -v "add-apt-repository" >/dev/null 2>&1; then
      sudo add-apt-repository --yes ppa:git-core/ppa
    fi
  fi
  sudo apt update
  sudo apt install -y "${packageName}"
}