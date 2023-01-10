#!/usr/bin/env bash

set -ex

name=${1:-"z2m"}

# absolute path of the folder containng the current script
script_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
templates_folder=$(realpath "${script_folder}/../templates")
output_folder=$(realpath "/mnt/$(iocage get -p)/iocage/bin/")
prestart_script_path="${output_folder}/${name}_prestart.sh"
poststart_script_path="${output_folder}/${name}_poststart.sh"

mkdir -p output_folder

iocage fetch -P zigbee2mqtt.json -n "${name}"
iocage stop "${name}"

JAILNAME="${name}"
POOLNAME=$(iocage get -p)
export JAILNAME POOLNAME

envsubst < "${templates_folder}/zigbee2mqtt_poststart.sh.template" > "${prestart_script_path}"
envsubst < "${templates_folder}/zigbee2mqtt_prestart.sh.template" > "${poststart_script_path}"

chmod +x "${prestart_script_path}" "${poststart_script_path}"

iocage set exec_poststart="${prestart_script_path}" "${name}"
iocage set exec_prestart="${poststart_script_path}" "${name}"
iocage set devfs_ruleset=5 "${name}"
iocage set boot=on "${name}"

iocage start "${name}"