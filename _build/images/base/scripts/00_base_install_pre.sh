#!/bin/bash

set -e

echo "[INFO] Updating, upgrading and installing packages with APT"
apt -y update
apt -y upgrade
