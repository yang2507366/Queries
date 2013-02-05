require "AutoreleasePool"

Object = {};

function Object:new(objectId)
    local obj = {};
    
    setmetatable(obj, self);
    self.__index = self;
    
    if objectId ~= nil then
        obj.objectId = objectId;
    end
--    obj:retain();
    
    return obj:autorelease();
end

function Object:dealloc()
    self.objectId = nil;
end

-- instance methods
function Object:id()
    return self.objectId;
end

function Object:setId(objectId)
    self.objectId = objectId;
end

function Object:release()
    local objId = self:id();
    if self:retainCount() == 1 then
        self:dealloc();
    end
    runtime::releaseObject(objId);
end

function Object:retain()
    runtime::retainObject(self:id());
    return self;
end

function Object:keep()
    return self:retain();
end

function Object:retainCount()
    return runtime::objectRetainCount(self:id());
end

function Object:equals(obj)
    if obj.id then
        local sb, se = string.find(self:id(), obj:id());
        if sb and se then
            return se == string.len(self:id());
        end
    end
    return false;
end

function Object:autorelease()
    local success = _autorelease_pool_addObject(self);
    if success == false then
        print("error, autorelease failed, no pool around");
    end
    return self;
end

function Object:hash()
    return runtime::invokeMethod(self:id(), "hash");
end

function Object:objCClassName()
    return runtime::objectClassName(self:id());
end

function Object:objCDescription()
    return runtime::objectDescription(self:id());
end

-- object convert
function oc(object, targetType)
    setmetatable(object, targetType);
end

