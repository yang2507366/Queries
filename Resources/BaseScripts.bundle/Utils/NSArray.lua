require "Object"
require "CommonUtils"

NSArray = {};
NSArray.__index = NSArray;
setmetatable(NSArray, Object);

function NSArray:get(arrId)
    local arr = Object:new(arrId);
    setmetatable(arr, self);
    
    return arr;
end

function NSArray:read(path)
    local arrId = runtime::invokeClassMethod("NSArray", "arrayWithContentsOfFile:", path);
    if string.len(arrId) ~= 0 then
        return self:get(arrId);
    end
    return nil;
end

function NSArray:arrayWithObject(obj)
    local objId = runtime::invokeClassMethod("NSArray", "arrayWithObject:", obj:id());
    return self:get(objId);
end

function NSArray:objectAtIndex(index)
    local objId = runtime::invokeMethod(self:id(), "objectAtIndex:", index);
    if isObjCObject(objId) then
        return Object:new(objId);
    else
        return objId;
    end
end

function NSArray:count()
    return tonumber(runtime::invokeMethod(self:id(), "count"));
end

function NSArray:writeToFile(path)
    runtime::invokeMethod(self:id(), "writeToFile:atomically:", path, toObjCBool(false));
end