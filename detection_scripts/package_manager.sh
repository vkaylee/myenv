#!/usr/bin/env bash
# Use by
# source <(cat "${DIR}/package_manager.sh")
# source <(curl -sSL "${url}/package_manager.sh")
# source <(wget -qO- "${url}/package_manager.sh")
if [[ -n "${MYENV_DEBUG}" ]]; then
  set -x
fi


if [[ -z "${MYENV_PACKAGE_MANAGER}" ]]; then
  # Package managers to check
  myenv_detect_2989829823_package_managers=(
    "apt"     # Debian/Ubuntu
    "apt-get" # Debian/Ubuntu
    "dnf"     # Fedora/RHEL (Red Hat Enterprise Linux)/CentOS/AlmaLinux/Rocky/Oracle/Mageia/OpenMandriva/PCLinuxOS/Scientific Linux
    "yum"     # Fedora/RHEL (Red Hat Enterprise Linux)/CentOS/AlmaLinux/Rocky/Oracle/Mageia/OpenMandriva/PCLinuxOS/Scientific Linux
    "zypper"  # openSUSE/SUSE Linux Enterprise/GeckoLinux/Tumbleweed/Leap
    "pacman"  # Arch Linux/Manjaro/EndeavourOS/Garuda Linux/ArcoLinux/Artix Linux
    "emerge"  # Gentoo Linux/Funtoo Linux
    "urpmi"   # Mageia/OpenMandriva/PCLinuxOS
    "nix-env" # NixOS/Guix System
    "pkg"     # FreeBSD/NetBSD/DragonFly BSD/OpenBSD
    "pkgutil" # Solaris 9/10/11 (OpenCSW)
    "pkg_add" # OpenBSD
    "apk"     # Alpine
    "tazpkg"  # Slitaz
  )

  # Iterate over package managers and check their availability
  for manager in "${myenv_detect_2989829823_package_managers[@]}"; do
    if command -v "${manager}" >/dev/null 2>&1; then
      export "MYENV_PACKAGE_MANAGER=${manager}"
      break
    fi
  done

  unset myenv_detect_2989829823_package_managers
fi