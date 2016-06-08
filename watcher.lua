

function load_state(pin)
  if pin < 50 then
    gpio.mode(pin, gpio.OUTPUT)
  end
  if file.open('pin_' .. pin, 'r') then
    state = tonumber(file.read(0))
    print(state)
    if pin < 50 then
      gpio.write(pin, state)
    end
    file.close()
    return state
  else
    if pin < 50 then
      save_state(pin, gpio.read(pin))
    else
      save_state(pin, 0)
    end
  end
end

function save_state(pin, state)
  file.open('pin_' .. pin, 'w+')
  file.writeline(state)
  file.close()
end


function check_hum ()
  local status,temp,hum = dht.readxx(dhtpin)
  -- dir = read_watch()
  if (status == dht.OK) then
    gpio.mode(FOGPIN, gpio.OUTPUT)
    if (hum >= MAX) or (load_state(50) == 1 and hum >= MED) then
      gpio.write(FOGPIN, gpio.HIGH) -- turn off
      save_state(FOGPIN, gpio.HIGH)
      save_state(50, 0)
      -- set_watch(0)
    end
    if hum <= MIN then
      gpio.write(FOGPIN, gpio.LOW) -- turn on
      save_state(FOGPIN, gpio.LOW)
      save_state(50, 1)
      -- set_watch(1)
    end
    -- print(dir)
    print(hum)
  end
end

load_state(FOGPIN)
load_state(LIGHTPIN)
check_hum()
tmr.alarm(0, INTERVAL, 1, check_hum)
