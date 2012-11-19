require "Object"

NSIndexPath = {};
NSIndexPath.__index = NSIndexPath;
setmetatable(NSIndexPath, Object);

function NSIndexPath:create(row, section)
    local indexPathId = runtime::invokeClassMethod("NSIndexPath", "indexPathForRow:inSection:", row, section);
    return self:get(indexPathId);
end

function NSIndexPath:get(indexPathId)
    local indexPath = Object:new(indexPathId);
    setmetatable(indexPath, self);
    
    return indexPath;
end

function NSIndexPath:section()
    return tonumber(runtime::invokeMethod(self:id(), "section"));
end

function NSIndexPath:row()
    return tonumber(runtime::invokeMethod(self:id(), "row"));
end