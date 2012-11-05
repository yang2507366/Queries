require "Object"
require "NSMutableArray"

NSMutableDictionary = {};
NSMutableDictionary.__index = NSMutableDictionary;
setmetatable(NSMutableDictionary, Object);

function NSMutableDictionary:create()
    local dictId = runtime::createObject("NSMutableDictionary", "init");
    print(dictId);
    return self:get(dictId);
end

function NSMutableDictionary:get(dictId)
    local dict = Object:new(dictId);
    setmetatable(dict, self);
    
    return dict;
end

function NSMutableDictionary:setObjectForKey(obj, key)
    if obj.id ~= nil then
        obj = obj:id();
    end
    runtime::invokeMethod(self:id(), "setObject:forKey:", obj, key);
end

function NSMutableDictionary:objectForKey(key)
    local objId = runtime::invokeMethod(self:id(), "objectForKey:", key);
    if isObjCObject(objId) then
        return Object:new(objId);
    else
        return objId;
    end
end

function NSMutableDictionary:allKeys()
    local arrId = runtime::invokeMethod(self:id(), "allKeys");
    return NSMutableArray:get(arrId);
end