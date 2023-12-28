#! /bin/bash

cd $(readlink -f .)
/usr/bin/lazygit "$@"
