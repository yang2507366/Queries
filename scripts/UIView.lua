require "Object"
require "UIColor"

UIView = {};
UIView.__index = UIView;
setmetatable(UIView, Object);

-- constant
UIViewAutoresizingNone = 0;
UIViewAutoresizingFlexibleLeftMargin = 1;
UIViewAutoresizingFlexibleWidth = 2;
UIViewAutoresizingFlexibleRightMargin = 4;
UIViewAutoresizingFlexibleTopMargin = 8;
UIViewAutoresizingFlexibleHeight = 16;
UIViewAutoresizingFlexibleBottomMargin = 32;

UIControlStateNormal = 0;
UIControlStateHighlighted = 1;
UIControlStateDisabled = 2;
UIControlStateSelected = 4;
UIControlStateApplication = 0x00FF0000;
UIControlStateReserved = 0xFF000000;

-- constructor
function UIView:create()
    local viewId = runtime::createObject("UIView", "init");
    return self:get(viewId);
end

function UIView:get(viewId)
    local view = Object:new(viewId);
    setmetatable(view, self);
    
    return view;
end

-- instance methods
function UIView:setFrame(x, y, width, height)
    local frame = x..","..y..","..width..","..height;
    ui::setViewFrame(self:id(), frame);
end

function UIView:frame()
    local frame = ui:getViewFrame(self:id());
    return frame;
end

function UIView:bounds()
    local x, y, width, height = ui::getViewBounds(self:id());
    
    return x, y, width, height;
end

function UIView:setBackgroundColor(color)
	runtime::invokeMethod(self:id(), "setBackgroundColor:", color:id());
end

function UIView:backgroundColor()
    local colorId = runtime::invokeMethod(self:id(), "backgroundColor");
    return UIColor:get(colorId);
end

function UIView:addSubview(subview)
    ui::addSubview(self:id(), subview:id());
end

function UIView:setAutoresizingMask(mask)
    runtime::invokeMethod(self:id(), "setAutoresizingMask:", mask);
end

function UIView:autoresizingMask()
    return runtime::invokeMethod(self:id(), "autoresizingMask");
end

function UIView:resignFirstResponder()
    runtime::invokeMethod(self:id(), "resignFirstResponder");
end

function UIView:becomeFirstResponder()
    runtime::invokeMethod(self:id(), "becomeFirstResponder");
end

function UIView:viewWithTag(tag, viewType)
    local viewId = runtime::invokeMethod(self:id(), "viewWithTag:", tag);
    local view = UIView:get(viewId);
    if viewType then
        setmetatable(view, viewType);
    end
    return view;
end

function UIView:setTag(tag)
    runtime::invokeMethod(self:id(), "setTag:", tag);
end

function UIView:tag()
    local tag = runtime::invokeMethod(self:id(), "tag");
    return tonumber(tag);
end
