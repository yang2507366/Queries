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

function ObjectCreate(objectId)
    return Object:new(objectId);
end