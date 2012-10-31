require "Object"
require "UIBarButtonItem"

UINavigationItem = {};
UINavigationItem.__index = UINavigationItem;
setmetatable(UINavigationItem, Object);

function UINavigationItem:get(naviItemId)
    local naviItem = Object:new(naviItemId);
    setmetatable(naviItem, self);
    
    return naviItem;
end

function UINavigationItem:setTitle(title)
    runtime::invokeMethod(self:id(), "setTitle:", title);
end

function UINavigationItem:rightBarButtonItem()
    local ri = runtime::invokeMethod(self:id(), "rightBarButtonItem");
    local bi = UIBarButtonItem:new(ri);
    return bi;
end

function UINavigationItem:setRightBarButtonItem(buttonItem)
    runtime::invokeMethod(self:id(), "setRightBarButtonItem:", buttonItem:id());
end