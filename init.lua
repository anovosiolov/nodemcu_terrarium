dofile('wifi.lua')

file.remove('server.lc')
file.remove('dht.lc')
file.remove('watcher.lc')
node.compile('server.lua')
node.compile('dht.lua')
node.compile('watcher.lua')

tmr.alarm(1,1000, 0, function()
  if wifi.sta.status() == 5 then
    tmr.stop(0)
    print(wifi.sta.getip())
    dofile('watcher.lc')
    dofile('server.lc')
  end
end)
