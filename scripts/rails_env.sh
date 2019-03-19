#!/bin/sh
export RAILS_ENV=production

export RBENV_RUBY_VERSION=2.6.1
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

RUBYOPT="$RUBYOPT -W0"

DIR="$(dirname "$0")"
FULL_DIR="$(readlink --canonicalize $DIR)"

flock -w 600 $FULL_DIR/rbenv_rehash.flock rbenv rehash
rbenv local $RBENV_RUBY_VERSION

cd $FULL_DIR/..
