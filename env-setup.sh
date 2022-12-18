#!/bin/bash

function getRegion() {
	cfg_region=$(aws configure get region)
	if [[ ${AWS_REGION} != "" ]]; then
		region=${AWS_REGION}
	elif [[ ${AWS_DEFAULT_REGION} != "" ]]; then
		region=${AWS_DEFAULT_REGION}
	elif [[ ${cfg_region} != "" ]]; then
		region=${cfg_region}
	fi
	echo "$region"
}

AWS_REGION=$(getRegion)
export AWS_REGION
TG_CONFIG="$1"
export TG_CONFIG
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query "Account" --output text --no-cli-pager)"
export AWS_ACCOUNT_ID
git_repo=$(git rev-parse --show-toplevel)
REPO=${GITHUB_ACTION_REPOSITORY:=$(basename "$git_repo")}
export REPO
