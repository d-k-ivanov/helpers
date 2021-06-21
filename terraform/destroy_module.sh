#!/usr/bin/env bash
if [ -z "$1" ] || [ $2 ]; then
	echo "Error: You should enter name of module and environment."
	echo "  Usage: $0 <module_name>"
    echo
	exit
fi
terraform plan -destroy -target module.${1} -out terraform.plan
