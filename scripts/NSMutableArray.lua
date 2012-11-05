require "Object"

NSMutableArray = {};
NSMutableArray.__index = NSMutableArray;
setmetatable(NSMutableArray, Object);

function NSMutableArray:create()
    local arrId = runtime::createObject("NSMutableArray", "init");
    
    return NSMutableArray:get(arrId);
end

function NSMutableArray:get(arrId)
    local arr = Object:new(arrId);
    setmetatable(arr, self);
    
    return arr;
end

function NSMutableArray:objectAtIndex(index)
    local objId = runtime::invokeMethod(self:id(), "objectAtIndex:", index);
    if isObjCObject(objId) then
        return Object:new(objId);
    else
        return objId;
    end
end

function NSMutableArray:addObject(obj)
    if obj:id() ~= nil then
        obj = obj:id();
    end
    return runtime::invokeMethod(self:id(), "addObject:", obj);
end

function NSMutableArray:removeObject(obj)
    runtime::invokeMethod(self:id(), "removeObject:", obj);
end

function NSMutableArray:removeObjectAtIndex(index)
    runtime::invokeMethod(self:id(), "removeObjectAtIndex:", index);
end

function NSMutableArray:count()
    return tonumber(runtime::invokeMethod(self:id(), "count"));
end