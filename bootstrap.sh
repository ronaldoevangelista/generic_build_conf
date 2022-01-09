#!/bin/sh

AUTOPROJ_INSTALL_URL=https://raw.githubusercontent.com/rock-core/autoproj/master/bin/autoproj_install

BOOTSTRAP_URL=git@github.com:Brazilian-Institute-of-Robotics/generic_build_conf.git

PWD=$(pwd)

AUTOPROJ_VERSION=""

MANIFEST_FILE=${PWD}/autoproj

BOOTSTRAP_BRANCH=master

BOOTSTRAP_MANIFEST=manifest

set -e
[ -f "autoproj_install" ] || wget -nv ${AUTOPROJ_INSTALL_URL}
[ -d ".autoproj" ] || {
  mkdir -p .autoproj
  cat <<EOF >.autoproj/config.yml
---
osdeps_mode: all
GITORIOUS: ssh
GITHUB: ssh
apt_dpkg_update: true
CODE_INTEGRATION: true
CODE_MANAGE_FOLDERS: true
CODE_ADD_CONFIG: true
USE_PYTHON: true
PYTHONPATH: /usr/bin/python2.7
EOF
}

export AUTOPROJ_OSDEPS_MODE=all
export AUTOPROJ_BOOTSTRAP_IGNORE_NONEMPTY_DIR=1

ruby autoproj_install
. ./env.sh
#autoproj bootstrap git ${BOOTSTRAP_URL}

aup
