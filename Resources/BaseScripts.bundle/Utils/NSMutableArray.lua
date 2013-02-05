require "NSArray"
require "AppContext"

NSMutableArray = {};
NSMutableArray.__index = NSMutableArray;
setmetatable(NSMutableArray, NSArray);

function NSMutableArray:create()
    local arrId = runtime::invokeClassMethod("NSMutableArray", "array");

    return NSMutableArray:get(arrId);
end

function NSMutableArray:get(arrId)
    local arr = NSArray:new(arrId);
    setmetatable(arr, self);
    
    return arr;
end

function NSMutableArray:read(path)
    local arrId = runtime::invokeClassMethod("NSMutableArray", "arrayWithContentsOfFile:", path);
    if string.len(arrId) ~= 0 then
        return self:get(arrId);
    end
    return nil;
end

function NSMutableArray:addObject(obj)
    if obj.id ~= nil then
        obj = obj:id();
    end
    runtime::invokeMethod(self:id(), "addObject:", obj);
end

function NSMutableArray:insertObject(obj, index)
    if obj.id ~= nil then
        obj = obj:id();
    end
    if not index then
        self:addObject(obj);
    else
        runtime::invokeMethod(self:id(), "insertObject:atIndex:", obj, index);
    end
end

function NSMutableArray:removeObject(obj)
    runtime::invokeMethod(self:id(), "removeObject:", obj);
end

function NSMutableArray:removeObjectAtIndex(index)
    runtime::invokeMethod(self:id(), "removeObjectAtIndex:", index);
end