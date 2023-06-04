#!/usr/bin/env zsh

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  if [[ -z ${packageName} ]]; then
    return
  fi
  dnf update
  dnf install "${packageName}"
}