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
    runtime::invokeMethod(self:id(), "writeToFile:atomically:", path, toObjBool(false));
end