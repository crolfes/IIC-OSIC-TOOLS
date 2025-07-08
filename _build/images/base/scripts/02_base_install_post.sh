#!/bin/bash

set -e

update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

cd /usr/lib/llvm-16/bin
for f in *; do rm -f /usr/bin/"$f"; \
    ln -s ../lib/llvm-16/bin/"$f" /usr/bin/"$f"
done

# Proxy setup for APT (auth with user/password does not work with add-apt-repository)
_proxy_detected () {
    if [[ ${http_proxy:-"unset"} != "unset" || ${https_proxy:-"unset"} != "unset" ]]; then
      return 0 
    else
      return 1
    fi
}

# Enable proxy auth for GIT
if _proxy_detected; then
    git config --global http.proxyAuthMethod 'basic'
    git config --global http.sslVerify "false"
fi

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean

# setup rust and cargo via rustup
echo "[INFO] Installing Rust and Cargo"
export RUSTUP_HOME=/tmp/rustup
export CARGO_HOME=/tmp/cargo
export PATH=$CARGO_HOME/bin:$PATH
rustup default stable

# FIXME maybe interesting for future cleanup (removal of -dev packages)
# apt list --installed | grep "\-dev" | grep automatic | cut -d'/' -f1 | xargs apt -y remove
# apt -y autoremove
