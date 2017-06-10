local pin = TEMPOUTPIN
local status,temp,hum = dht.readxx(pin)
local outside = ""
if( status == dht.OK ) then
  outside = "# HELP dht_22_"..pin.."_temp Temperature outside Terrarium\n"
  .."# TYPE dht_22_"..pin.."_temp gauge\n"
  .."dht_22_"..pin.."_temp{graphname=\"dht_22_"..pin.."\",instance=\"terrarium\",label=\"temp\",type=\"gauge\"} "..temp.."\n"
  .."# HELP dht_22_"..pin.."_hum Humidity outside Terrarium\n"
  .."# TYPE dht_22_"..pin.."_hum gauge\n"
  .."dht_22_"..pin.."_hum{graphname=\"dht_22_"..pin.."\",instance=\"terrarium\",label=\"hum\",type=\"gauge\"} "..hum.."\n";
elseif( status == dht.ERROR_CHECKSUM ) then
  outside = "";
elseif( status == dht.ERROR_TIMEOUT ) then
  outside = "";
end

return(outside)