#!/bin/bash
set -e

if [ "$1" = 'start' ]; then
  echo 'Making sure the database is up to date...'
  cd /apps/ledger/app
  gosu ledger bundle exec rake db:migrate

  echo 'Starting server'
  puma
else
  exec "$@"
fi
