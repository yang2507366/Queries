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
    print("autorelease:"..self:id());
    local success = _autorelease_pool_addObject(self);
    if success == false then
        print("autorelease failed, no pool");
    end
    
    return self;
end