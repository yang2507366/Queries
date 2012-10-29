--require "Recyclable"
--require "Utils"

Object = {};

function Object:new(objectId)
	self.__index = self;
    local obj = {};
    setmetatable(obj, Object);
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
    --recycleObjectById(self:id());
end