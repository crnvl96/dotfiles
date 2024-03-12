#! /bin/bash

cd $(readlink -f .)
$(which lazygit) "$@"
