files = file.list()

if (files['server.lc'] == nil) then node.compile('server.lua') end
if (files['dht.lc'] == nil) then node.compile('dht.lua') end
if (files['ds18b20.lc'] == nil) then node.compile('ds18b20.lua') end
if (files['watcher.lc'] == nil) then node.compile('watcher.lua') end

TEMPOUTPIN = 6
TEMPININ = 7
MIN = 40
MED = 50
MAX = 80
MINTEMP = 25
MAXTEMP = 29
INTERVAL = 28*1000
FOGPIN = 4
LIGHTPIN = 1
UVPIN = 2
LIGHT_ENABLED = 52
light_enabled = 0
light_on = 0

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function()
  wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
  wifi.sta.eventMonStop()
  print(wifi.sta.getip())
  dofile('watcher.lc')
  dofile('server.lc')
end)

dofile('wifi.lua')
