require "NSDictionary"

NSMutableDictionary = {};
NSMutableDictionary.__index = NSMutableDictionary;
setmetatable(NSMutableDictionary, NSDictionary);

function NSMutableDictionary:create()
    local dictId = runtime::invokeClassMethod("NSMutableDictionary", "dictionary");
    
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