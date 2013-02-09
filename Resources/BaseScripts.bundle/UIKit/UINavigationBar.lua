require "UIView"

UINavigationBar = {};
UINavigationBar.__index = UINavigationBar;
setmetatable(UINavigationBar, UIView);

function UINavigationBar:create()
    local objId = runtime::invokeClassMethod("UINavigationBar", "new");
    runtime::invokeMethod(objId, "autorelease");
    return self:get(objId);
end

function UINavigationBar:get(objId)
    local obj = UIView:new(objId);
    setmetatable(obj, self);
    
    return obj;
end

function UINavigationBar:pushNavigationItem(naviItem, animated)
    runtime::invokeMethod(self:id(), "pushNavigationItem:animated:", naviItem:id(), toObjCBool(animated));
end

function UINavigationBar:popNavigationItem(animated)
    runtime::invokeMethod(self:id(), "popNavigationItemAnimated:", toObjCBool(animated));
end

function UINavigationBar:barStyle()
    return tonumber(runtime::invokeMethod(self:id(), "barStyle"));
end

function UINavigationBar:setBarStyle(barStyle)
    runtime::invokeMethod(self:id(), "setBarStyle:", barStyle);
end