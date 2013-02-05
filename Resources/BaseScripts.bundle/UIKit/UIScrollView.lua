require "UIView"

UIScrollView = {};
UIScrollView.__index = UIScrollView;
setmetatable(UIScrollView, UIView);

function UIScrollView:create()

end

function UIScrollView:get(objId)
    local obj = UIView:new(objId);
    setmetatable(obj, self);
    
    return obj;
end

function UIScrollView:setContentInset(top, left, bottom, right)
    local inset = top..","..left..","..bottom..","..right;
    runtime::invokeMethod(self:id(), "setContentInset:", inset);
end