files = file.list()

if (files['server.lc'] == nil) then node.compile('server.lua') end
if (files['dht.lc'] == nil) then node.compile('dht.lua') end
if (files['watcher.lc'] == nil) then node.compile('watcher.lua') end

wifi.sta.eventMonReg(wifi.STA_GOTIP, function()
  wifi.sta.eventMonStop("unreg all")
  print(wifi.sta.getip())
  dofile('watcher.lc')
  dofile('server.lc')
end)

wifi.sta.eventMonStart()

dofile('wifi.lua')


