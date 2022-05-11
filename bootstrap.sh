#!/bin/sh
# Copyright (c) 2022
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

export AUTOPROJ_VERSION=""
export BOOTSTRAP_MANIFEST=manifest
export AUTOPROJ_OSDEPS_MODE=all
export AUTOPROJ_BOOTSTRAP_IGNORE_NONEMPTY_DIR=1
export PYTHON_EXECUTABLE=/usr/bin/python3

PWD=$(pwd)
MANIFEST_FILE=${PWD}/autoproj

BOOTSTRAP_BRANCH=feat-add-build-files

AUTOPROJ_INSTALL_URL=https://raw.githubusercontent.com/rock-core/autoproj/master/bin/autoproj_install
BOOTSTRAP_URL=git@github.com:ronaldoevangelista/generic_build_conf.git

[ -f "autoproj_install" ] || wget -nv ${AUTOPROJ_INSTALL_URL}

[ -f "autoproj.gemfile" ] || { cat <<EOF > autoproj.gemfile; }
source "https://rubygems.org"
gem "autoproj", github: 'rock-core/autoproj'
gem "autobuild", github: 'rock-core/autobuild'
EOF



set -e
[ -f "autoproj_install" ] || wget -nv ${AUTOPROJ_INSTALL_URL}
[ -d ".autoproj" ] || {
  mkdir -p .autoproj
  cat <<EOF >.autoproj/config.yml
---
apt_dpkg_update: true
osdeps_mode: all
GITORIOUS: ssh
GITHUB: ssh
USE_PYTHON: true
python_executable: "${PYTHON_EXECUTABLE}"
GITHUB_ROOT: 'git@github.com:'
GITHUB_PUSH_ROOT: 'git@github.com:'
GITHUB_PRIVATE_ROOT: 'git@github.com:'
GITORIOUS_ROOT: 'git@gitorious.org:'
GITORIOUS_PUSH_ROOT: 'git@gitorious.org:'
GITORIOUS_PRIVATE_ROOT: 'git@gitorious.org:'
ros_version: 2
ros_distro: 'foxy'
user_shells:
- bash
EOF
}

ruby autoproj_install --gemfile=autoproj.gemfile
. ./env.sh

autoproj bootstrap git ${BOOTSTRAP_URL} branch=${BOOTSTRAP_BRANCH}

aup

amake --verbose