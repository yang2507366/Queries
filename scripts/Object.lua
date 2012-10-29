require "Recyclable"
require "Utils"

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
    releaseById(self:id());
end