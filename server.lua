fogpin = 1
lightpin = 2

function get_metrics ()
  local d = ""
  -- fog
  d = d .. "# HELP humidizer Humidizer is on or off\n"
  .. "# TYPE humidizer gauge\n"
  gpio.mode(fogpin, gpio.OUTPUT)
  local val = gpio.read(fogpin)
  if val == 0 then
    val = 100
  else
    val = 0
  end
  d = d .. "humidizer{graphname=\"humidizer\",label=\"on\",type=\"gauge\"} "
  .. val .. "\n"
  -- light
  d = d .. "# HELP light_"..lightpin.." Humidizer is on or off\n"
  .. "# TYPE light_"..lightpin.." gauge\n"
  gpio.mode(lightpin, gpio.OUTPUT)
  local val = gpio.read(lightpin)
  if val == 0 then
   val = 100
  else
   val = 0
  end
  d = d .. "light_"..lightpin.."{graphname=\"light\",label=\"on\",type=\"gauge\"} "
  .. val .. "\n"
  return d
end

function save_state(pin, state)
  file.open('pin_'..pin, 'w+')
  file.writeline(state)
  file.close()
end

-- create a server
-- 30s time out for a inactive client
sv=net.createServer(net.TCP, 30)

-- server listen on 80
sv:listen(80,function(conn)
  conn:on("receive", function(client, pl)
    if string.match(pl, "metrics") then
      -- print(pl)
      local buff = ""
      buff = buff .. "HTTP/1.1 200 OK\n"
      buff = buff .. "Content-Type:text/plain; version=0.0.4\n"
      buff = buff .. "\n"
      data = dofile('dht.lc')
      data = data .. get_metrics()
      buff = buff .. data
      buff = buff .. "# HELP nodemcu_heap nodeMCU heap\n"
      .."# TYPE nodemcu_heap gauge\n"
      .."nodemcu_heap{graphname=\"nodemcu\",label=\"heap\",type=\"gauge\"} "..tostring(node.heap()).."\n";
      client:send(buff)
    elseif string.match(pl, "fogon") then
      gpio.mode(fogpin, gpio.OUTPUT)
      gpio.write(fogpin, gpio.LOW)
      save_state(fogpin, gpio.LOW)
      save_state('fog', 0)
      print("Fog on")
      client:send("Fog on. OK")
    elseif string.match(pl, "fogoff") then
      gpio.mode(fogpin, gpio.OUTPUT)
      gpio.write(fogpin, gpio.HIGH)
      save_state(fogpin, gpio.HIGH)
      save_state('fog', 0)
      print("Fog off")
      client:send("Fog off. OK")
    elseif string.match(pl, "lighton") then
      gpio.mode(lightpin, gpio.OUTPUT)
      gpio.write(lightpin, gpio.LOW)
      save_state(lightpin, gpio.LOW)
      print("Light on")
      client:send("Light on. OK")
    elseif string.match(pl, "lightoff") then
      gpio.mode(lightpin, gpio.OUTPUT)
      gpio.write(lightpin, gpio.HIGH)
      save_state(lightpin, gpio.HIGH)
      print("Light off")
      client:send("Light off. OK")
    else
      client:send("OK")
    end
    client:close()
    collectgarbage()
   end)
end)
