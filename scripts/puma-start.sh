#!/bin/bash
DIR="$(dirname "$0")"
source "$DIR/rails_env.sh"

scripts/puma-init.sh start > /dev/null
