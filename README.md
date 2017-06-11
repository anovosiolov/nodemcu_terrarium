# nodeMCU Terrarium

NodeMCU controlled Terrarium

## Components

*   nodemcu rom v 2.1.0 with gpio, dht, net, timer, 1-wire modules
*   <http://prometheus.io> server for collecting metrics
*   nodeMCU module
*   1x DHT_22 module
*   1x DS18B20 module
*   relay module
*   humidizer

## Example configuration

DHT on pin 7 is inside, DHT on pin 6 is on outside. On pin 1 is humidizer,
pin 2 is light control (heat) - keeps temperature between `MAXTEMP` and `MINTEMP`.

Server responds on

*   `/metrics` - shows metrics for collecting by prometheus
*   `/uvon` - switches pin 1 on
*   `/uvoff` - switches pin 1 off
*   `/lighton` - switches pin 2 on
*   `/lightoff` - switches pin 2 off
*   `/lighten` - enable light
*   `/lightdis` - disable light
*   `/forgon` - switches pin 4 on
*   `/fogoff` - turns pin 4 off

Connection settings are in set in `wifi.lua`.

## Notes

*   rename  `wifi.lua.default` to `wifi.lua`

flash rom

```shell
sudo ./esptool.py --port /dev/ttyUSB0 --baud 115200 write_flash 0x00000 rom.bin
```
