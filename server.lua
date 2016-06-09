function get_metrics ()
  local d = ""
  -- fog
  d = d .. "# HELP humidizer Humidizer is on or off\n"
  .. "# TYPE humidizer gauge\n"
  gpio.mode(FOGPIN, gpio.OUTPUT)
  local val = gpio.read(FOGPIN)
  if val == 0 then
    val = 100
  else
    val = 0
  end
  d = d .. "humidizer{graphname=\"humidizer\",instance=\"terrarium\",label=\"on\",type=\"gauge\"} "
  .. val .. "\n"
  -- light
  d = d .. "# HELP light_"..LIGHTPIN.." Humidizer is on or off\n"
  .. "# TYPE light_"..LIGHTPIN.." gauge\n"
  gpio.mode(LIGHTPIN, gpio.OUTPUT)
  local val = gpio.read(LIGHTPIN)
  if val == 0 then
   val = 100
  else
   val = 0
  end
  d = d .. "light_"..LIGHTPIN.."{graphname=\"light\",instance=\"terrarium\",label=\"on\",type=\"gauge\"} "
  .. val .. "\n"
  return d
end

function save_state(pin, state)
  file.open('pin_'..pin, 'w+')
  file.writeline(state)
  file.close()
end

function lightset(i)
  if light_enabled or i == gpio.HIGH then
    gpio.mode(LIGHTPIN, gpio.OUTPUT)
    gpio.write(LIGHTPIN, i)
    save_state(LIGHTPIN, i)
    if i == gpio.LOW then
      light_on = 1 -- turned on
    else
      light_on = 0 -- turned off
    end
  end
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
      .."nodemcu_heap{graphname=\"nodemcu\",instance=\"terrarium\",label=\"heap\",type=\"gauge\"} "..tostring(node.heap()).."\n"
      .. "# HELP nodemcu_uptime nodeMCU uptime\n"
      .. "# TYPE nodemcu_uptime counter\n"
      .. "nodemcu_uptime{graphname=\"nodemcu\",instance=\"terrarium\",label=\"uptime\",type=\"counter\"} " .. tostring(tmr.time()) .. "\n";
      client:send(buff)
    elseif string.match(pl, "fogon") then
      gpio.mode(FOGPIN, gpio.OUTPUT)
      gpio.write(FOGPIN, gpio.LOW)
      save_state(FOGPIN, gpio.LOW)
      save_state('fog', 0)
      print("Fog on")
      client:send("Fog on. OK")
    elseif string.match(pl, "fogoff") then
      gpio.mode(FOGPIN, gpio.OUTPUT)
      gpio.write(FOGPIN, gpio.HIGH)
      save_state(FOGPIN, gpio.HIGH)
      save_state('fog', 0)
      print("Fog off")
      client:send("Fog off. OK")
    elseif string.match(pl, "lighton") then
      if light_enabled then
        lightset(gpio.LOW)
        print("Light on")
        client:send("Light on. OK")
      else
        print("Light off. Not enabled.")
        client:send("Light on. FAILED, enable it first")
      end
    elseif string.match(pl, "lightoff") then
      lightset(gpio.HIGH)
      print("Light off")
      client:send("Light off. OK")
    elseif string.match(pl, "lighten") then
      light_enabled = true
      print("Light enabled")
      client:send("Light enable. OK")
    elseif string.match(pl, "lightdis") then
      light_enabled = false
      print("Light disabled")
      client:send("Light disable. OK")
    else
      client:send("OK")
    end
    client:close()
    collectgarbage()
   end)
end)
