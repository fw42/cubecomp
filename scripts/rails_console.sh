#!/bin/bash
DIR="$(dirname "$0")"
source "$DIR/rails_env.sh"
bundle exec rails console
