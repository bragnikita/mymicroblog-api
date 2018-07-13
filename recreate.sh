#!/usr/bin/env bash
set -e
RAILS_ENV=development rails db:migrate:down VERSION=$1
RAILS_ENV=development rails db:migrate:up VERSION=$1
RAILS_ENV=test rails db:migrate:down VERSION=$1
RAILS_ENV=test rails db:migrate:up VERSION=$1
annotate
