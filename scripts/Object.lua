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
    obj:retain();
    
    return obj:autorelease();
end

-- instance methods
function Object:id()
    return self.objectId;
end

function Object:setId(objectId)
    self.objectId = objectId;
end

function Object:release()
--    releaseObjectById(self:id());
    local recycled = runtime::releaseObject(self:id());
    if recycled then
        self:dealloc();
    end
end

function Object:retain()
    runtime::retainObject(self:id());
    return self;
end

function Object:keep()
    return self:retain();
end

function Object:retainCount()
    
end

function Object:dealloc()
    
end

function Object:autorelease()
    local success = _autorelease_pool_addObject(self);
    if success == false then
        print("error, autorelease failed, no pool around");
    end
    return self;
end

function objectConvert(object, targetType)
    setmetatable(object, targetType);
end