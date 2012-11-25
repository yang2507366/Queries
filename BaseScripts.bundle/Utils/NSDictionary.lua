require "Object"
require "NSArray"

NSDictionary = {};
NSDictionary.__index = NSDictionary;
setmetatable(NSDictionary, Object);

function NSDictionary:get(dictId)
    local dict = Object:new(dictId);
    setmetatable(dict, self);
    
    return dict;
end

function NSDictionary:objectForKey(key)
    local objId = runtime::invokeMethod(self:id(), "objectForKey:", key);
    if isObjCObject(objId) then
        return Object:new(objId);
    else
        return objId;
    end
end

function NSDictionary:allKeys()
    local arrId = runtime::invokeMethod(self:id(), "allKeys");
    return NSArray:get(arrId);
end

function NSDictionary:count()
    return tonumber(runtime::invokeMethod(self:id(), "count"));
end