#!/bin/sh
export RAILS_ENV=production

export RBENV_RUBY_VERSION=2.4.0
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

rbenv rehash
rbenv local $RBENV_RUBY_VERSION

DIR="$(dirname "$0")"
FULL_DIR="$(readlink --canonicalize $DIR)"
cd $FULL_DIR/..
