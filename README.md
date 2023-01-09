# custom-iocage-plugins-index

## installation

Download a plugin manifest file to your local file system.
```
fetch https://raw.githubusercontent.com/partikus/custom-iocage-plugin-index/master/zigbee2mqtt.json
```
Install the plugin.  Adjust the network settings as needed.
```
iocage fetch -P zigbee2mqtt.json -n zigbee2mqtt
iocage fetch -P mosquitto.json -n mosquitto
iocage fetch -P homeassistant.json -n homeassistant
iocage fetch -P node-red.json -n node-red
```
