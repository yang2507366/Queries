require "Recyclable"
require "Utils"
require "AutoreleasePool"

Object = {};

function Object:new(objectId)
    local obj = {};
    
    setmetatable(obj, self);
    self.__index = self;
    
    if objectId ~= nil then
        obj.objectId = objectId;
    end
    
    return obj;
end

-- instance methods
function Object:id()
    return self.objectId;
end

function Object:setId(objectId)
	self.objectId = objectId;
end

function Object:release()
    releaseObjectById(self:id());
end

function Object:autorelease()
    _autorelease_pool_addObject(self);
    
    return self;
end