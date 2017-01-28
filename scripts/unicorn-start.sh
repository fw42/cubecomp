#!/bin/sh
export RBENV_RUBY_VERSION=2.3.1
DIR="$(dirname "$0")"
$DIR/unicorn-init.sh start > /dev/null
