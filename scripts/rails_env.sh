#!/bin/sh
export RBENV_RUBY_VERSION=2.3.1
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
rbenv rehash
rbenv local $RBENV_RUBY_VERSION
DIR="$(dirname "$0")"
cd $DIR/..
export RAILS_ENV=production
