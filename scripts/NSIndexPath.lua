require "Object"

NSIndexPath = {};
NSIndexPath.__index = NSIndexPath;
setmetatable(NSIndexPath, Object);

function NSIndexPath:get(indexPathId)
    local indexPath = Object:new(indexPathId);
    setmetatable(indexPath, self);
    
    return indexPath;
end

function NSIndexPath:section()
    return runtime::invokeMethod(self:id(), "section");
end

function NSIndexPath:row()
    return runtime::invokeMethod(self:id(), "row");
end