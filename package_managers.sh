#!/usr/bin/env zsh
myenv_package_managers_632264331_exitcode=255
#### Define all methods here like an interface
### Example method to define
### The body must return myenv_package_managers_632264331_exitcode
### Must implement this method in package_managers/[packageManager].sh with any body you need
# myenv_package_managers_632264331_install(){
#   return ${myenv_package_managers_632264331_exitcode}
# }

myenv_package_managers_632264331_install(){
  local packageName="${1-}"
  echo "${packageName}"
  return ${myenv_package_managers_632264331_exitcode}
}

if [[ -z "${MYENV_PACKAGE_MANAGER}" ]]; then
  return ${myenv_package_managers_632264331_exitcode}
fi
# Load package_managers/[packageManager].sh for overriding
myenv_package_managers_632264331_file="${MYENV_DIR}/package_managers/${MYENV_PACKAGE_MANAGER}.sh"
if [ -r "${myenv_package_managers_632264331_file}" ]; then
  # shellcheck source=package_managers/[packageManager].sh
  source "${myenv_package_managers_632264331_file}"
fi

# Check for implementation
myenv_package_managers_632264331_need_implement_count=0
for functionName in $(print -l ${(ok)functions} | grep '^myenv_package_managers_632264331_'); do
  eval "${functionName}"
  if [ $? -eq ${myenv_package_managers_632264331_exitcode} ]; then
    # Notify to implement
    myenv_lib_983459816_typing_style_print "Please implement ${functionName} in ${myenv_package_managers_632264331_file}"; printf "\n"
    # Remove method
    unset -f "${functionName}"
    ((myenv_package_managers_632264331_need_implement_count++))
  fi
done

if [[ ${myenv_package_managers_632264331_need_implement_count} -ne 0 ]]; then
  return ${myenv_package_managers_632264331_exitcode}
fi