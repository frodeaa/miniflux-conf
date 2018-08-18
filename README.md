# miniflux-conf

A collection of useful miniflux configuration snippets
with simple scripts to manage install and upgrade of
miniflux

**NOTE** installs miniflux for linux armv7

## Prerequisite

install postgresql, create user and database and create
the extension hstore as superuser

    apt install postgresql
    createuser -P miniflux
    createdb -O miniflux miniflux
    psql miniflux -c 'create extension hstore'

## Install miniflux

run the `bin/install.sh` script to install latest version of miniflux

## Upgrade miniflux

Use the `bin/upgrade.sh` script to upgrade existing miniflux to
latest released version.
