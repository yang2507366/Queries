require "AutoreleasePool"
require "CommonUtils"

Object = {};
Object.__index = Object;

function Object:new(objectId)
    local obj = {};
    setmetatable(obj, self);
    
    if objectId ~= nil then
        obj.objectId = objectId;
    else
        obj._retainCount = 1;
    end
--    obj:retain();
    obj:init();
    return obj:autorelease();
end

function Object:init()
    
end

function Object:dealloc()
    self:releaseFields();
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
    if objId then
        if self:retainCount() == 1 then
            self:dealloc();
        end
        runtime::releaseObject(objId);
    else
        self._retainCount = self._retainCount - 1;
        if self._retainCount == 0 then
            self:dealloc();
        end
    end
end

function Object:retain()
    if self:id() then
        runtime::retainObject(self:id());
    else
        self._retainCount = self._retainCount + 1;
    end
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

function Object.objectIsKindOfClass(objId, className)
    return toLuaBool(runtime::invokeClassMethod("LIRuntimeUtils", "object:isKindOfClass:", objId, className));
end

function Object:isKindOfClass(className)
    return self.objectIsKindOfClass(self:id(), className);
end

function Object:objCDescription()
    return runtime::objectDescription(self:id());
end

function Object:releaseFields()
    for k, v in pairs(self) do
        if v and type(v) == "table" and v.id then
            v:release();
        end
    end
end

function Object:setAssociatedObject(obj)
    if obj.id then
        obj = obj:id();
    end
    runtime::invokeClassMethod("LIRuntimeUtils", "setAssociatedObjectFor:key:value:policy:override", self:id(), "", obj, 1, toObjCBool(true));
end

function Object:associatedObject()
    local objId = runtime::invokeClassMethod("LIRuntimeUtils", "getAssociatedObjectWithAppId:forObject:key:", AppContext.current(), self:id(), "");
    return Object:new(objId);
end

function Object:removeAssociatedObject()
    runtime::invokeClassMethod("LIRuntimeUtils", "removeAssociatedObjectsForObject:", self:id());
end

-- object type convert
function object_type_covert(object, targetType)
    setmetatable(object, targetType);
end

