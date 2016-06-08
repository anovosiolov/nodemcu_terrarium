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

function check_hum()
  local status,temp,hum = dht.readxx(dhtpin)
  -- dir = read_watch()
  if (status == dht.OK) then
    if (hum >= MAX) or (load_state(50) == 1 and hum >= MED) then
      gpio.mode(FOGPIN, gpio.OUTPUT)
      gpio.write(FOGPIN, gpio.HIGH) -- turn off
      save_state(FOGPIN, gpio.HIGH)
      save_state(50, 0)
      -- set_watch(0)
    end
    if hum <= MIN then
      gpio.mode(FOGPIN, gpio.OUTPUT)
      gpio.write(FOGPIN, gpio.LOW) -- turn on
      save_state(FOGPIN, gpio.LOW)
      save_state(50, 1)
      -- set_watch(1)
    end
    -- print(dir)
    print(hum)
  end
end

function check_temp()
  local status,temp,hum = dht.readxx(dhtpin)
  if (status == dht.OK) then
    if temp < MINTEMP and light_off then
      light_set(gpio.LOW) -- turn on light
      save_state(LIGHTPIN, gpio.LOW)
    elseif temp > MAXTEMP and light_on then
      light_set(gpio.HIGH) -- turn on light
      save_state(LIGHTPIN, gpio.HIGH)
    end
  end
end

function check_all()
  check_hum()
  check_temp()
end

load_state(FOGPIN)
load_state(LIGHTPIN)
check_all()
tmr.alarm(0, INTERVAL, 1, check_all)
