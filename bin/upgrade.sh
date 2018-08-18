#!/usr/bin/env bash

# Upgrade miniflux installation.
# Download latest version from GitHub

set -e pipefail

latest="$(curl https://api.github.com/repos/miniflux/miniflux/releases/latest -s)"
current_version="$(DATABASE_URL='' miniflux -version | grep -Po '(\d+.\d+.\d+)')"
latest_version="$(echo "$latest" | jq '.tag_name' -r)"
download_file="$(mktemp -d -t "miniflux_$latest_version.XXX")/miniflux"
browser_download_url="$(echo "$latest" | jq '.assets[] | select(.name=="miniflux-linux-armv7") | .browser_download_url' -r)"
install_dir="$(which miniflux)"

echo -e "Miniflux: \n installed: $current_version latest: $latest_version"

if [ "$current_version" == "$latest_version" ]
then
	echo "latest version installed"
	exit 0
fi


echo "start download of $latest_version to $download_file"
curl --location -o "$download_file" "$browser_download_url"

chmod +x "$download_file"

echo "install miniflux $latest_version to $install_dir"
sudo install -b -c "$download_file" "$install_dir"

echo "restarting miniflux"
sudo sudo systemctl restart miniflux

echo "upgrade from $current_version to $latest_version completed"
