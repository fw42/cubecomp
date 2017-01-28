#!/bin/bash
DIR="$(dirname "$0")"
source "$DIR/rails_env.sh"

scripts/unicorn-init.sh start > /dev/null
