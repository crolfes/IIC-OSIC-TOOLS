#!/bin/bash

set -e

apt list --installed | grep "\-dev" | grep automatic | cut -d'/' -f1 | xargs apt -y remove
apt -y autoremove
