#!/usr/bin/env bash

# Install miniflux.
# Create miniflux group/user
# Download latest version from GitHub

set -e pipefail

if [ -x "$(command -v miniflux)" ]; then
    echo 'Error: miniflux is already installed.' >&2
    exit 1
fi

install_dir="/usr/local/bin/"
release_url="https://api.github.com/repos/miniflux/miniflux/releases/latest"
latest="$(curl ${release_url} -s)"
latest_version="$(echo "$latest" | jq '.tag_name' -r)"
download_file="$(mktemp -d -t "miniflux_$latest_version.XXX")/miniflux"
browser_download_url="$(echo "$latest" | jq '.assets[] | select(.name=="miniflux-linux-armv7") | .browser_download_url' -r)"

echo "start download of $latest_version to $download_file"
curl --location -o "$download_file" "$browser_download_url"

chmod +x "$download_file"

echo "install miniflux $latest_version to $install_dir"
sudo install -D -m 755 -c "$download_file" "$install_dir"

echo "install system/miniflux.service to /etc/systemd/system/"
sudo install -D -m 644 ./system/miniflux.service \
    /etc/systemd/system/miniflux.service

echo "create miniflux group"
getent group miniflux >/dev/null || \
    sudo groupadd -r miniflux

echo "create miniflux user"
getent passwd miniflux >/dev/null || \
    sudo useradd -r -g miniflux -d /dev/null \
        -s /sbin/nologin \
        -c "Miniflux Daemon" miniflux

sudo systemctl enable /etc/systemd/system/miniflux.service

printf "installation complete, run: \
  \n \
  \n systemctl edit miniflux \
  \n \
        \n  [Service] \
        \n  Environment=\"DATABASE_URL=postgres://...?sslmode=disable\" \
  \n \
  \n systemctl start miniflux.service\n"
