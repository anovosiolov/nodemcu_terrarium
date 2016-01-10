wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","PASSWORD")
wifi.sta.connect()
wifi.sta.setip({ip="192.168.150.55",netmask="255.255.255.0",gateway="192.168.150.1"})
