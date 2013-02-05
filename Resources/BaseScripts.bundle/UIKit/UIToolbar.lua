require "UIView"

UIToolbar = {};
UIToolbar.__index = UIToolbar;
setmetatable(UIToolbar, UIView);

function UIToolbar:create()
    local objId = runtime::invokeClassMethod("UIToolbar", "new");
    
    return self:get(objId);
end

function UIToolbar:get(objId)
    local obj = UIView:new(objId);
    setmetatable(obj, self);
    
    return obj;
end

function UIToolbar:setItems(items)
    runtime::invokeMethod(self:id(), "setItems:", items:id());
end