require "Object"
require "AppContext"

LocationManager = {};
LocationManager.__index = LocationManager;
setmetatable(LocationManager, Object);

function LocationManager:create()
    local lmId = runtime::invokeClassMethod("LILocationManager", "create:", AppContext.current());
    
    return self:get(lmId);
end

function LocationManager:get(lmId)
    local locationMgr = Object:new(lmId);
    setmetatable(locationMgr, self);
    
    LocationManagerEventProxyTable[lmId] = locationMgr;
    runtime::invokeMethod(lmId, "setDidUpdateToLocation:", "LocationManager_didUpdateToLocation");
    runtime::invokeMethod(lmId, "setDidFailWithError:", "LocationManager_didFailWithError");
    
    return locationMgr;
end

function LocationManager:dealloc()
    LocationManagerEventProxyTable[self:id()] = nil;
    Object.dealloc(self);
end

function LocationManager:startUpdatingLocation()
    runtime::invokeMethod(self:id(), "startUpdatingLocation");
end

function LocationManager:didUpdateToLocation(latitude, longitude)
    
end

function LocationManager:didFailWithError()
    
end

-- event proxy
LocationManagerEventProxyTable = {};

function LocationManager_didUpdateToLocation(lmId, latitude, longitude)
    local lm = LocationManagerEventProxyTable[lmId];
    if lm then
        lm:didUpdateToLocation(tonumber(latitude), tonumber(longitude));
    end
end

function LocationManager_didFailWithError(lmId)
    local lm = LocationManagerEventProxyTable[lmId];
    if lm then
        lm:didFailWithError();
    end
end