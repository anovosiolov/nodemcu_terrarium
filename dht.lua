local pin = 6
local status,temp,hum = dht.readxx(pin)
local outside = ""
if( status == dht.OK ) then
  outside = "# HELP dht_22_"..pin.."_temp Temperature outside Terrarium\n"
  .."# TYPE dht_22_"..pin.."_temp gauge\n"
  .."dht_22_"..pin.."_temp{graphname=\"dht_22_"..pin.."\",label=\"temp\",type=\"gauge\"} "..temp.."\n"
  .."# HELP dht_22_"..pin.."_hum Humidity outside Terrarium\n"
  .."# TYPE dht_22_"..pin.."_hum gauge\n"
  .."dht_22_"..pin.."_hum{graphname=\"dht_22_"..pin.."\",label=\"hum\",type=\"gauge\"} "..hum.."\n";
elseif( status == dht.ERROR_CHECKSUM ) then
  outside = "";
elseif( status == dht.ERROR_TIMEOUT ) then
  outside = "";
end

local pin = 7
local status,temp,hum = dht.readxx(pin)
local inside = ""
if( status == dht.OK ) then
  inside = "# HELP dht_22_"..pin.."_temp Temperature in Terrarium\n"
  .."# TYPE dht_22_"..pin.."_temp gauge\n"
  .."dht_22_"..pin.."_temp{graphname=\"dht_22_"..pin.."\",label=\"temp\",type=\"gauge\"} "..temp.."\n"
  .."# HELP dht_22_"..pin.."_hum Humidity in Terrarium\n"
  .."# TYPE dht_22_"..pin.."_hum gauge\n"
  .."dht_22_"..pin.."_hum{graphname=\"dht_22_"..pin.."\",label=\"hum\",type=\"gauge\"} "..hum.."\n";
elseif( status == dht.ERROR_CHECKSUM ) then
  inside = "";
elseif( status == dht.ERROR_TIMEOUT ) then
  inside = "";
end

return(outside .. inside);
