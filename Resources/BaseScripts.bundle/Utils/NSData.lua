require "Object"
require "CommonUtils"

NSData = {};
NSData.__index = NSData;
setmetatable(NSData, Object);

function NSData:get(dataId)
    local data = Object:new(dataId);
    setmetatable(data, self);
    
    return data;
end

function NSData:dataWithContentsOfFile(path)
    local dataId = runtime::invokeClassMethod("NSData", "dataWithContentsOfFile:", path);
    return self:get(dataId);
end

function NSData:dataWithContentsOfURL(URL)
    local dataId = runtime::invokeClassMethod("NSData", "dataWithContentsOfURL:", URL:id());
    return self:get(dataId);
end

function NSData:dataWithData(data)
    local dataId = runtime::invokeClassMethod("NSData", "dataWithData:", data:id());
    return self:get(dataId);
end

function NSData:length()
    return tonumber(runtime::invokeMethod(self:id(), "length"));
end

function NSData:description()
    return runtime::invokeMethod(self:id(), "description");
end

function NSData:writeToFile(path, atomically--[[option]])
    if atomically == nil then
        atomically = false;
    end
    
    runtime::invokeMethod(self:id(), "writeToFile:atomically:", path, toObjCBool(atomically));
end

function NSData:writeToURL(URL, atomically--[[option]])
    if atomically == nil then
        atomically = false;
    end
    
    runtime::invokeMethod(self:id(), "writeToURL:atomically:", URL:id(), toObjCBool(atomically));
end
