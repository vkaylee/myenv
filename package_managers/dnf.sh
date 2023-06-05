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
  sudo dnf -y update
  sudo dnf install -y "${packageName}"
}