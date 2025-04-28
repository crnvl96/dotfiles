#! /bin/bash

RUBY_DEBUG_HOST=127.0.0.1 RUBY_DEBUG_PORT=38698 rdbg -O -c -- bin/rails server
