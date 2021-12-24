#!/usr/bin/env bash

setAlias(){
  local aliasCommand=$1
  local realCommand=$2
  # shellcheck disable=SC2139
  alias "${aliasCommand}"="${realCommand}"
  echo "You can use command '${aliasCommand}' as '${realCommand}'"
}
# Alias for docker-compose
setAlias 'dc' 'docker-compose'
