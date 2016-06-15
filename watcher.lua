local status, temp, hum

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

function lightset(i)
  gpio.mode(LIGHTPIN, gpio.OUTPUT)
  gpio.write(LIGHTPIN, i)
  save_state(LIGHTPIN, i)
  if i == gpio.LOW then
    light_on = 1 -- turned on
  else
    light_on = 0 -- turned off
  end
end

function check_hum()
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
  end
  print(hum)
end

function check_temp()
  if ((temp < MINTEMP) and (light_on == 0) and (light_enabled == 1)) then
    lightset(gpio.LOW) -- turn on light
    save_state(LIGHTPIN, gpio.LOW)
  elseif temp > MAXTEMP and light_on == 1 then
    lightset(gpio.HIGH) -- turn on light
    save_state(LIGHTPIN, gpio.HIGH)
  end
end

function check_all()
  status,temp,hum = dht.readxx(DHTPIN)
  if (status == dht.OK) then
    check_hum()
    check_temp()
  end
end

load_state(FOGPIN)
load_state(LIGHTPIN)
light_enabled = load_state(LIGHT_ENABLED)
check_all()
tmr.alarm(0, INTERVAL, 1, check_all)
