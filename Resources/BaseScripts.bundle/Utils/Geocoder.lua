require "Object"
require "AppContext"

Geocoder = {};
Geocoder.__index = Geocoder;
setmetatable(Geocoder, Object);

function Geocoder:create()
    local gId = runtime::invokeClassMethod("LIGeocoder", "create:", AppContext:current());
    
    return self:get(gId);
end

function Geocoder:get(gId)
    local g = Object:new(gId);
    setmetatable(g, self);
    
    GeocoderEventProxyTable[gId] = g;
    runtime::invokeMethod(gId, "setDidRecieveLocality:", "Geocoder_didSuccess");
    runtime::invokeMethod(gId, "setDidFailWithError:", "Geocoder_didError");
    
    return g;
end

function Geocoder:dealloc()
    runtime::invokeMethod(self:id(), "cancel");
    super:dealloc();
end

function Geocoder:geocode(latitude, longitude)
    runtime::invokeMethod(self:id(), "geocodeWithLatitude:longitude:", latitude, longitude);
end

function Geocoder:didSuccess(locality, address)
    
end

function Geocoder:didFailWithError()
    
end

-- event proxy
GeocoderEventProxyTable = {};

function Geocoder_didSuccess(gId, locality, address)
    local g = GeocoderEventProxyTable[gId];
    if g then
        g:didSuccess(locality, address);
    end
end

function Geocoder_didError(gId)
    local g = GeocoderEventProxyTable[gId];
    if g then
        g:didFailWithError();
    end
end