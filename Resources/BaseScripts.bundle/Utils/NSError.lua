require "Object"

NSError = {};
NSError.__index = NSError;
setmetatable(NSError, Object);

function NSError:get(objId)
    local obj = Object:new(objId);
    setmetatable(obj, self);
    
    return obj;
end

function NSError:code()
    return tonumber(runtime::invokeMethod(self:id(), "code"));
end

function NSError:domain()
    return runtime::invokeMethod(self:id(), "domain");
end

function NSError:localizedDescription()
    return runtime::invokeMethod(self:id(), "localizedDescription");
end