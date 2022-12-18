#!/bin/bash
set -eo pipefail # script will exit on error

# TODO: Verify provided environment name matches a config file
# TODO: Consider using dev as default when not specified
if [ $# -lt 2 ]; then
	echo "Usage: source $0 <env> <tg-command> [tg-options]"
	return
fi

config=$1
shift
TG_CMD=$*
parent_dir=$(dirname "$0")
. "$parent_dir/env-setup.sh" "$config"
echo "TG_CONFIG: $TG_CONFIG"

echo -e "\n----- Executing Terragrunt $TG_CMD -----"
terragrunt "$TG_CMD"
