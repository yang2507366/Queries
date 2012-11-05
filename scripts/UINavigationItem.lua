require "Object"
require "UIBarButtonItem"

UINavigationItem = {};
UINavigationItem.__index = UINavigationItem;
setmetatable(UINavigationItem, Object);

-- constructor
function UINavigationItem:get(naviItemId)
    local naviItem = Object:new(naviItemId);
    setmetatable(naviItem, self);
    
    return naviItem;
end

-- instance methods
function UINavigationItem:setTitle(title)
    runtime::invokeMethod(self:id(), "setTitle:", title);
end

function UINavigationItem:rightBarButtonItem()
    local ri = runtime::invokeMethod(self:id(), "rightBarButtonItem");
    local bi = UIBarButtonItem:get(ri);
    return bi;
end

function UINavigationItem:setRightBarButtonItem(buttonItem)
    if buttonItem then
        runtime::invokeMethod(self:id(), "setRightBarButtonItem:", buttonItem:id());
    else
        runtime::invokeMethod(self:id(), "setRightBarButtonItem:");
    end
end