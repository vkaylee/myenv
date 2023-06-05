#!/usr/bin/env bash

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  if [[ -z ${packageName} ]]; then
    return
  fi
  sudo yum -y update
  sudo yum install -y "${packageName}"
}