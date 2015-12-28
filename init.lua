dofile('wifi.lua')

file.remove('server.lc')
file.remove('dht.lc')
file.remove('watcher.lc')
node.compile('server.lua')
node.compile('dht.lua')
node.compile('watcher.lua')

dofile('watcher.lc')
dofile('server.lc')
