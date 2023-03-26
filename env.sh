#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
if [ -r "${work_dir}/.env" ]; then
  set -a
  # shellcheck source=currentDir/.env
  source <(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${work_dir}/.env")
  set +a
  echo "Some environments in ${work_dir}/.env have been set!"
fi
