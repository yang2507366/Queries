require "UIView"

UINavigationBar = {};
UINavigationBar.__index = UINavigationBar;
setmetatable(UINavigationBar, UIView);

function UINavigationBar:create()
    local objId = runtime::invokeClassMethod("UINavigationBar", "new");
    
    return self:get(objId);
end

function UINavigationBar:get(objId)
    local obj = UIView:new(objId);
    setmetatable(obj, self);
    
    return obj;
end