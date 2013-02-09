require "Object"
require "AppContext"

NSURL = {};
NSURL.__index = NSURL;
setmetatable(NSURL, Object);

function NSURL:create(URLString, isfileURL)
    local objId;
    if isfileURL then
        objId = runtime::invokeClassMethod("NSURL", "fileURLWithPath:", URLString);
    else
        objId = runtime::invokeClassMethod("NSURL", "URLWithString:", URLString);
    end
    return self:get(objId);
end

function NSURL:get(objId)
    local obj = Object:new(objId);
    setmetatable(obj, self);
    
    return obj;
end

function NSURL:absoluteString()
    return runtime::invokeMethod(self:id(), "absoluteString");
end