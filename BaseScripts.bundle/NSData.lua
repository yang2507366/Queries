require "Object"

NSData = {};
NSData.__index = NSData;
setmetatable(NSData, Object);

function NSData:get(dataId)
    local data = Object:new(dataId);
    setmetatable(data, self);
    
    return data;
end