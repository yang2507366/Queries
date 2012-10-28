import Recyclable.lua;
import Utils.lua;

local Object = {};
Object.__index = Object;
Object.id = "";

function Object:new(objectId)
    local obj = {};
    setmetatable(obj, Object);
    if objectId ~= nil then
        obj.id = objectId;
    end
    
    return obj;
end

-- functions
function ObjectCreate(objectId)
    return Object:new(objectId);
end

function ObjectRelease(object)
    if object.id then
        ObjectReleaseById(object.id);
    end
end

function ObjectReleaseById(objectId)
    recycleObjectById(objectId);
end