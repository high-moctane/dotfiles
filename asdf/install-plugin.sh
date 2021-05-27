#!/bin/bash

# args
# name, version, repo

set -x

if [[ $# < 2 ]]; then
  echo "invalid args ${@}" >&2
  exit 1
fi

readonly name=${1}
readonly version=${2}
readonly repo=${3}


export CFLAGS=""


. ${1}/home/shell_common.sh
asdf plugin add ${name} ${repo}


set -e


export CFLAGS="-march=native -mtune=native -O2 -pipe -static"
export CXXFLAGS="${CFLAGS}"

if [[ $(uname) == "Linux" && ${name} == "luaJIT" ]]; then
  export LUAJIT_CONFIGURE_OPTIONS="INSTALL_LIB=${ASDF_DIR}/installs/luaJIT/$(asdf latest luaJIT)/lib/x86_64-linux-gnu"
fi

if [[ $(uname) == "Darwin" ]]
  export MACOSX_DEPLOYMENT_TARGET="$(shell sw_vers -productVersion | sed -e "s/\.[0-9]*$$//")"
fi

if $(asdf plugin list | grep luaJIT) > /dev/null; then
  export ASDF_VIM_CONFIG="
    --enable-fail-if-missing
    --with-compiledby=asdf
    --enable-multibyte
    --enable-cscope
    --enable-terminal
    --enable-luainterp
    --with-luajit
    --with-lua-prefix=${ASDF_DIR}/installs/luaJIT/$(shell $(call asdf-latest-version,luaJIT))
    --enable-gui=no
    --without-x"
fi


asdf plugin update ${name}
asdf install ${name} ${version}
asdf global ${name} ${version}
