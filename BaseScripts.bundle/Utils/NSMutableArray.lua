require "NSArray"

NSMutableArray = {};
NSMutableArray.__index = NSMutableArray;
setmetatable(NSMutableArray, NSArray);

function NSMutableArray:create()
    local arrId = runtime::createObject("NSMutableArray", "init");
    
    return NSMutableArray:get(arrId);
end

function NSMutableArray:get(arrId)
    local arr = NSArray:new(arrId);
    setmetatable(arr, self);
    
    return arr;
end

function NSMutableArray:addObject(obj)
    if obj.id ~= nil then
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