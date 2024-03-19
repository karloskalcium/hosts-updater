#!/usr/bin/env bash
# Build and replace new hosts file with whitelist in local dir
# from https://github.com/StevenBlack/hosts
set -eou pipefail

docker run --pull always --rm -it -v /etc/hosts:/etc/hosts \
-v "/Users/kbrown/dev/util/hosts-updater/whitelist:/hosts/whitelist" \
-v "/Users/kbrown/dev/util/hosts-updater/hosts_output:/hosts/hosts_output" \
ghcr.io/stevenblack/hosts:latest updateHostsFile.py --auto \
--output hosts_output --extensions fakenews gambling --whitelist whitelist

echo "Done generating hosts file, now moving to /etc/hosts"
sudo cp -f /private/etc/hosts "/private/etc/hosts.bak.$(date +%Y%m%d_%H%M%S)"
sudo mv -f hosts_output/hosts /private/etc/hosts

# flush dns cache
echo "Flushing cache"
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "Cache flushed"

echo "Opening chrome so you can clear cache in chrome"
open -a "Google Chrome.app" "chrome://net-internals/#dns"
echo "All done!"
