files = file.list()

if (files['server.lc'] == nil) then node.compile('server.lua') end
if (files['dht.lc'] == nil) then node.compile('dht.lua') end
if (files['watcher.lc'] == nil) then node.compile('watcher.lua') end

DHTPIN = 7
MIN = 40
MED = 50
MAX = 80
MINTEMP = 26
MAXTEMP = 28
INTERVAL = 28*1000
FOGPIN = 2
LIGHTPIN = 1
light_enabled = 0
light_on = 0

wifi.sta.eventMonReg(wifi.STA_GOTIP, function()
  wifi.sta.eventMonStop("unreg all")
  print(wifi.sta.getip())
  dofile('watcher.lc')
  dofile('server.lc')
end)

wifi.sta.eventMonStart()

dofile('wifi.lua')
