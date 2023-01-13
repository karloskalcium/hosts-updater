#!/usr/bin/env bash
# Build and replace new hosts file with whitelist in local dir
# from https://github.com/StevenBlack/hosts
set -eou pipefail

echo "Copying minimal hosts file to /etc/hosts"
sudo cp -f hosts.minimal /private/etc/hosts

# flush dns cache
echo "Flushing cache"
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "Cache flushed"

echo "Opening chrome so you can clear cache in chrome"
open -a "Google Chrome.app" "chrome://net-internals/#dns"
echo "All done!"
