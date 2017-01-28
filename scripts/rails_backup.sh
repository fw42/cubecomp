#!/bin/bash
DIR="$(dirname "$0")"
source "$DIR/rails_env.sh"

bundle exec rake db:dump

cd db/backup/
DATE=$(date +"%Y-%m-%d-%H-%M-%S")
tar cfz "$DATE-system.tar.gz" ../../public/system/ 2>&1 | grep -v "Removing leading"
