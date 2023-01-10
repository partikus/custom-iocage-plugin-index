#!/usr/bin/env bash

set -ex

name=${1:-"z2m"}
interfaces=${2:-"vnet0:bridge20"}

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

rm -rf "${prestart_script_path}" "${poststart_script_path}" || true

envsubst < "${templates_folder}/zigbee2mqtt_prestart.sh.template" > "${prestart_script_path}"
envsubst < "${templates_folder}/zigbee2mqtt_poststart.sh.template" > "${poststart_script_path}"

chmod +x "${prestart_script_path}" "${poststart_script_path}"

iocage set exec_prestart="${prestart_script_path}" "${name}"
iocage set exec_poststart="${poststart_script_path}" "${name}"
iocage set devfs_ruleset=5 "${name}"
iocage set boot=on "${name}"
iocage set interfaces="${interfaces}" "${name}"
iocage set vnet_default_interface="auto" "${name}"
iocage set vnet="on" "${name}"

iocage start "${name}"