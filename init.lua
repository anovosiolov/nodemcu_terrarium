dofile('wifi.lua')

if (files['server.lc'] == nil) then node.compile('server.lua') end
if (files['dht.lc'] == nil) then node.compile('dht.lua') end
if (files['watcher.lc'] == nil) then node.compile('watcher.lua') end

tmr.alarm(1,1000, 0, function()
  if wifi.sta.status() == 5 then
    tmr.stop(0)
    print(wifi.sta.getip())
    dofile('watcher.lc')
    dofile('server.lc')
  end
end)
