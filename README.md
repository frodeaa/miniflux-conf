# miniflux-conf

A collection of useful miniflux configuration snippets
with simple scripts to manage install and upgrade of
miniflux

## Run miniflux with systemd

Copy the miniflux.service to the systemd system folder
and configure the DATABASE_URL to use with systemclt edit.

    cp system/miniflux.service /etc/systemd/system/

    # configure
    systemctl edit miniflux

    [Service]
    Environment="DATABASE_URL=postgres://<user>:<pass>@<origin>/<database>?sslmode=disable"

Run `systemctl enable` to tell systemd to start miniflux automatically
at boot.

    systemctl enable miniflux.service
