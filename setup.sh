#!/bin/bash
# Take working directory
this_file_path="$(readlink -f "$0")"
work_dir=$(dirname "${this_file_path}")
is_root_user() {
  # Returns 0 if root, 1 if non-root
  if [[ $EUID -eq 0 || $(id -u) -eq 0 ]]; then
    return 0 # Return 0 if root
  fi
  return 1 # Return 1 if non-root
}

# Need to run as root
if ! is_root_user > /dev/null 2>&1; then
  echo "You must run this script ${this_file_path} by root permission"
  exit 1
fi

# Continue
