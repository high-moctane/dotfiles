#!/bin/bash

# args
# dotfiles_dir, name, version, repo

set -x

if [[ $# < 2 ]]; then
  echo "invalid args ${@}" >&2
  exit 1
fi

readonly dotfiles_dir=${1}
readonly name=${2}
readonly version=${3}
readonly repo=${4}


. ${dotfiles_dir}/home/shell_common.sh

asdf plugin add ${name} ${repo}


set -e


export CFLAGS="-march=native -mtune=native -O2 -pipe"
export CXXFLAGS="${CFLAGS}"


if [[ $(uname) == "Darwin" ]]; then
  export MACOSX_DEPLOYMENT_TARGET="$(shell sw_vers -productVersion | sed -e 's/\.[0-9]*$$//')"
fi


asdf plugin update ${name}
asdf install ${name} ${version}
asdf global ${name} ${version}
