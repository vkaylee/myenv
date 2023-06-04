#!/usr/bin/env zsh

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  if [[ -z ${packageName} ]]; then
    return
  fi
  sudo dnf update
  sudo dnf install "${packageName}"
}