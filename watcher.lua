dhtpin = 7
fogpin = 1
lightpin = 2
min = 40
med = 50
max = 80
interval = 30000

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
    gpio.mode(fogpin, gpio.OUTPUT)
    if (hum >= max) or (load_state(50) == 1 and hum >= med) then
      gpio.write(fogpin, gpio.HIGH) -- turn off
      save_state(fogpin, gpio.HIGH)
      save_state(50, 0)
      -- set_watch(0)
    end
    if hum <= min then
      gpio.write(fogpin, gpio.LOW) -- turn on
      save_state(fogpin, gpio.LOW)
      save_state(50, 1)
      -- set_watch(1)
    end
    -- print(dir)
    print(hum)
  end
end

load_state(fogpin)
load_state(lightpin)
check_hum()
tmr.alarm(0, interval, 1, check_hum)
